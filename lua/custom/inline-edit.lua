local M = {}

local SYSTEM_PROMPT = table.concat({
  'You are an inline code editor inside Neovim.',
  'You receive a code selection, its surrounding context, and an instruction.',
  'Apply the instruction to the SELECTION ONLY and reply with the replacement code.',
  'Rules:',
  '- Output only the replacement for the selection. No explanations, no markdown fences.',
  '- Keep the original indentation style and leading indentation of the first line.',
  '- Do not include the surrounding context in your output.',
  '- If the instruction cannot be applied, output the selection unchanged.',
}, '\n')

local CONTEXT_LINES = 40

local function strip_fences(text)
  local stripped = text:gsub('^%s*```[%w_%-]*\n', ''):gsub('\n```%s*$', '')
  return stripped
end

local function show_pending(buffer, line, namespace)
  vim.api.nvim_buf_set_extmark(buffer, namespace, line, 0, {
    virt_text = { { '  claude is editing…', 'Comment' } },
    virt_text_pos = 'eol',
  })
end

local function run(target)
  local buffer = target.buffer
  local namespace = vim.api.nvim_create_namespace 'claude-inline-edit'
  show_pending(buffer, target.first - 1, namespace)

  local total_lines = vim.api.nvim_buf_line_count(buffer)
  local context_before = vim.api.nvim_buf_get_lines(buffer, math.max(0, target.first - 1 - CONTEXT_LINES), target.first - 1, false)
  local context_after = vim.api.nvim_buf_get_lines(buffer, target.last, math.min(total_lines, target.last + CONTEXT_LINES), false)

  local input = table.concat({
    'File: ' .. vim.api.nvim_buf_get_name(buffer),
    'Filetype: ' .. vim.bo[buffer].filetype,
    '',
    '<context_before>',
    table.concat(context_before, '\n'),
    '</context_before>',
    '',
    '<selection>',
    table.concat(target.lines, '\n'),
    '</selection>',
    '',
    '<context_after>',
    table.concat(context_after, '\n'),
    '</context_after>',
    '',
    '<instruction>',
    target.instruction,
    '</instruction>',
  }, '\n')

  vim.system(
    { 'claude', '-p', '--model', 'haiku', '--output-format', 'text', '--system-prompt', SYSTEM_PROMPT },
    { stdin = input, text = true },
    vim.schedule_wrap(function(result)
      vim.api.nvim_buf_clear_namespace(buffer, namespace, 0, -1)
      if not vim.api.nvim_buf_is_valid(buffer) then
        return
      end
      if result.code ~= 0 then
        vim.notify('Claude inline edit failed:\n' .. (result.stderr or ''), vim.log.levels.ERROR)
        return
      end
      local output = strip_fences((result.stdout or ''):gsub('%s+$', ''))
      if output == '' then
        vim.notify('Claude returned nothing', vim.log.levels.WARN)
        return
      end
      local replacement = vim.split(output, '\n', { plain = true })
      if vim.api.nvim_buf_line_count(buffer) < target.last then
        vim.notify('Buffer changed while waiting, edit skipped', vim.log.levels.WARN)
        return
      end
      vim.api.nvim_buf_set_lines(buffer, target.first - 1, target.last, false, replacement)
      local window = vim.fn.bufwinid(buffer)
      if window ~= -1 then
        vim.api.nvim_win_set_cursor(window, { target.first, 0 })
      end
    end)
  )
end

local function open_prompt(target)
  local prompt_buffer = vim.api.nvim_create_buf(false, true)
  vim.bo[prompt_buffer].buftype = 'nofile'
  vim.bo[prompt_buffer].bufhidden = 'wipe'
  vim.bo[prompt_buffer].filetype = 'markdown'

  local width = math.min(80, vim.o.columns - 4)
  local height = 6
  local window = vim.api.nvim_open_win(prompt_buffer, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = 'minimal',
    border = 'rounded',
    title = ' Claude · ' .. #target.lines .. ' lines selected · Enter to send, q to cancel ',
    title_pos = 'center',
  })
  vim.wo[window].wrap = true
  vim.wo[window].linebreak = true

  local function close()
    if vim.api.nvim_win_is_valid(window) then
      vim.api.nvim_win_close(window, true)
    end
  end

  local function send()
    local instruction = vim.trim(table.concat(vim.api.nvim_buf_get_lines(prompt_buffer, 0, -1, false), '\n'))
    close()
    if instruction == '' then
      return
    end
    target.instruction = instruction
    run(target)
  end

  vim.keymap.set('n', '<CR>', send, { buffer = prompt_buffer, desc = 'Send instruction to Claude' })
  vim.keymap.set('n', 'q', close, { buffer = prompt_buffer, desc = 'Cancel' })
  vim.cmd.startinsert()
end

function M.edit_selection()
  local buffer = vim.api.nvim_get_current_buf()
  local start_row = vim.fn.getpos('v')[2]
  local end_row = vim.fn.getpos('.')[2]
  local first, last = math.min(start_row, end_row), math.max(start_row, end_row)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'nx', false)

  open_prompt {
    buffer = buffer,
    first = first,
    last = last,
    lines = vim.api.nvim_buf_get_lines(buffer, first - 1, last, false),
  }
end

return M

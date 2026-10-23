return {
  'folke/sidekick.nvim',
  event = 'VeryLazy',
  opts = {
    nes = { enabled = true },
    cli = { mux = { enabled = false } },
  },
  keys = {
    {
      '<Tab>',
      function()
        if not require('sidekick').nes_jump_or_apply() then
          return '<Tab>'
        end
      end,
      mode = 'n',
      expr = true,
      desc = 'Jump to or apply next edit suggestion',
    },
  },
  config = function(_, opts)
    require('sidekick').setup(opts)

    -- Sidekick draws suggestions at the edit location, which is often off-screen.
    -- Show a cue on the cursor line so an off-screen suggestion is noticeable.
    local namespace = vim.api.nvim_create_namespace 'sidekick-offscreen-hint'
    local group = vim.api.nvim_create_augroup('sidekick-offscreen-hint', { clear = true })

    local function clear_hint()
      for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buffer) then
          vim.api.nvim_buf_clear_namespace(buffer, namespace, 0, -1)
        end
      end
    end

    vim.api.nvim_create_autocmd('User', {
      group = group,
      pattern = 'SidekickNesShow',
      callback = function()
        clear_hint()
        local edit = require('sidekick.nes').get()[1]
        if not edit or edit.buf ~= vim.api.nvim_get_current_buf() then
          return
        end
        local edit_line = edit.from[1] + 1
        local first_visible, last_visible = vim.fn.line 'w0', vim.fn.line 'w$'
        if edit_line >= first_visible and edit_line <= last_visible then
          return
        end
        local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
        vim.api.nvim_buf_set_extmark(edit.buf, namespace, cursor_line - 1, 0, {
          virt_text = { { ' ⇥ Tab: suggestion at line ' .. edit_line, 'Comment' } },
          virt_text_pos = 'eol',
        })
      end,
    })

    vim.api.nvim_create_autocmd('User', {
      group = group,
      pattern = 'SidekickNesHide',
      callback = clear_hint,
    })
  end,
}

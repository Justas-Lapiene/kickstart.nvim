return {
  'sindrets/diffview.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons' },
  cmd = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffviewClose', 'DiffviewToggleFiles' },
  keys = {
    { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = 'Diff: working tree vs index' },
    { '<leader>gD', '<cmd>DiffviewOpen origin/master...HEAD --imply-local<cr>', desc = 'Diff: branch vs master' },
    { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = 'Diff: current file history' },
    { '<leader>gH', '<cmd>DiffviewFileHistory<cr>', desc = 'Diff: repo history' },
    { '<leader>gq', '<cmd>DiffviewClose<cr>', desc = 'Diff: close' },
  },
  config = function(_, opts)
    require('diffview').setup(opts)

    -- Keep the diff in sync with whatever file ends up in the right pane,
    -- e.g. after a gd jump: show its diff when it is part of the view, or an
    -- empty left pane when it is unchanged.
    local group = vim.api.nvim_create_augroup('diffview-follow-right-pane', { clear = true })
    local blank_left = false

    -- Switch the view to `entry`, keeping the cursor where the jump put it.
    local function show_entry(view, entry, window)
      blank_left = false
      local cursor = vim.api.nvim_win_get_cursor(window)
      vim.api.nvim_create_autocmd('User', {
        group = group,
        pattern = 'DiffviewDiffBufWinEnter',
        once = true,
        callback = function()
          if vim.api.nvim_win_is_valid(window) then
            pcall(vim.api.nvim_win_set_cursor, window, cursor)
          end
        end,
      })
      entry.opened = true
      view:set_file(entry)
    end

    vim.api.nvim_create_autocmd('BufEnter', {
      group = group,
      callback = function(event)
        vim.schedule(function()
          if not vim.api.nvim_buf_is_valid(event.buf) then
            return
          end
          local view = require('diffview.lib').get_current_view()
          if not view or not view.cur_layout or not view.files then
            return
          end
          local layout = view.cur_layout
          local window = vim.api.nvim_get_current_win()
          if not layout.b or window ~= layout.b.id or vim.api.nvim_win_get_buf(window) ~= event.buf then
            return
          end
          local path = vim.api.nvim_buf_get_name(event.buf)
          if vim.bo[event.buf].buftype ~= '' or not path:match '^/' then
            return
          end
          local current = view.panel.cur_file
          if current and current.absolute_path == path then
            if blank_left then
              show_entry(view, current, window)
            end
            return
          end
          for _, entry in view.files:iter() do
            if entry.absolute_path == path then
              show_entry(view, entry, window)
              return
            end
          end
          local empty = vim.api.nvim_create_buf(false, true)
          vim.bo[empty].bufhidden = 'wipe'
          vim.api.nvim_win_set_buf(layout.a.id, empty)
          vim.wo[layout.a.id].diff = false
          vim.wo[window].diff = false
          blank_left = true
        end)
      end,
    })
  end,
  opts = {
    enhanced_diff_hl = true,
    hooks = {
      -- GitHub style: red tints on the old side, green tints on the new side,
      -- flat grey filler without dashes.
      diff_buf_win_enter = function(_, window_id, context)
        local side = context.symbol == 'a' and 'DiffAdd:GithubDiffDeleteLine,DiffChange:GithubDiffDeleteLine,DiffText:GithubDiffDeleteWord'
          or 'DiffAdd:GithubDiffAddLine,DiffChange:GithubDiffAddLine,DiffText:GithubDiffAddWord'
        vim.wo[window_id].winhl = side .. ',DiffDelete:GithubDiffFiller'
        vim.wo[window_id].fillchars = 'diff: '
        vim.wo[window_id].foldenable = false
      end,
    },
    view = {
      default = { layout = 'diff2_horizontal', winbar_info = true },
      merge_tool = { layout = 'diff3_mixed' },
    },
    file_panel = {
      listing_style = 'tree',
      win_config = { position = 'left', width = 35 },
    },
    keymaps = {
      view = {
        { 'n', 'q', '<cmd>DiffviewClose<cr>', { desc = 'Close diffview' } },
        { 'n', '<leader>e', '<cmd>DiffviewToggleFiles<cr>', { desc = 'Toggle file panel' } },
        { 'n', ']c', ']czz', { desc = 'Next hunk, centered' } },
        { 'n', '[c', '[czz', { desc = 'Previous hunk, centered' } },
      },
      file_panel = {
        { 'n', 'q', '<cmd>DiffviewClose<cr>', { desc = 'Close diffview' } },
        { 'n', '<leader>e', '<cmd>DiffviewToggleFiles<cr>', { desc = 'Toggle file panel' } },
      },
      file_history_panel = {
        { 'n', 'q', '<cmd>DiffviewClose<cr>', { desc = 'Close diffview' } },
        { 'n', '<leader>e', '<cmd>DiffviewToggleFiles<cr>', { desc = 'Toggle file panel' } },
      },
    },
  },
}

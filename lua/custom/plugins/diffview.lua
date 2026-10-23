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
    local blank_left = false
    vim.api.nvim_create_autocmd('BufEnter', {
      group = vim.api.nvim_create_augroup('diffview-follow-right-pane', { clear = true }),
      callback = function(event)
        local view = require('diffview.lib').get_current_view()
        if not view or not view.cur_layout or not view.files then
          return
        end
        local layout = view.cur_layout
        local window = vim.api.nvim_get_current_win()
        if not layout.b or window ~= layout.b.id or vim.bo[event.buf].buftype ~= '' then
          return
        end
        local path = vim.api.nvim_buf_get_name(event.buf)
        local current = view.panel.cur_file
        if current and current.absolute_path == path then
          if blank_left then
            blank_left = false
            view:set_file(current)
          end
          return
        end
        for _, entry in view.files:iter() do
          if entry.absolute_path == path then
            blank_left = false
            view:set_file(entry)
            return
          end
        end
        local empty = vim.api.nvim_create_buf(false, true)
        vim.bo[empty].bufhidden = 'wipe'
        vim.api.nvim_win_set_buf(layout.a.id, empty)
        vim.wo[layout.a.id].diff = false
        vim.wo[window].diff = false
        blank_left = true
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

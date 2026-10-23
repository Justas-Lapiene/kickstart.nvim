return {
  'sindrets/diffview.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons' },
  cmd = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffviewClose' },
  keys = {
    { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = 'Diff: working tree vs index' },
    { '<leader>gD', '<cmd>DiffviewOpen origin/master...HEAD --imply-local<cr>', desc = 'Diff: branch vs master' },
    { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = 'Diff: current file history' },
    { '<leader>gH', '<cmd>DiffviewFileHistory<cr>', desc = 'Diff: repo history' },
    { '<leader>gq', '<cmd>DiffviewClose<cr>', desc = 'Diff: close' },
  },
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
        { 'n', ']c', ']czz', { desc = 'Next hunk, centered' } },
        { 'n', '[c', '[czz', { desc = 'Previous hunk, centered' } },
      },
      file_panel = {
        { 'n', 'q', '<cmd>DiffviewClose<cr>', { desc = 'Close diffview' } },
      },
      file_history_panel = {
        { 'n', 'q', '<cmd>DiffviewClose<cr>', { desc = 'Close diffview' } },
      },
    },
  },
}

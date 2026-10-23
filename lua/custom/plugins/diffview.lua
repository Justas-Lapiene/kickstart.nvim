return {
  'sindrets/diffview.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons' },
  cmd = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffviewClose' },
  keys = {
    { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = 'Diff: working tree vs index' },
    { '<leader>gD', '<cmd>DiffviewOpen origin/master...HEAD<cr>', desc = 'Diff: branch vs master' },
    { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = 'Diff: current file history' },
    { '<leader>gH', '<cmd>DiffviewFileHistory<cr>', desc = 'Diff: repo history' },
    { '<leader>gq', '<cmd>DiffviewClose<cr>', desc = 'Diff: close' },
  },
  opts = {
    enhanced_diff_hl = true,
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

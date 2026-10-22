return {
  {
    'folke/ts-comments.nvim',
    opts = {},
    event = 'VeryLazy',
  },
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {},
  },
}

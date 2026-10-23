return {
  {
    'folke/ts-comments.nvim',
    opts = {},
    event = 'VeryLazy',
  },
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {
      -- typescript-tools builds its tsserver launcher from the *current* buffer
      -- the first time a client starts, and Neovim starts clients on a later
      -- tick, so inside diffview the current buffer can be a panel or git
      -- snapshot whose name fails its validity assert. Skip such buffers and
      -- initialise the launcher explicitly from the real file instead.
      root_dir = function(bufnr, on_dir)
        local utils = require 'typescript-tools.utils'
        local provider = require 'typescript-tools.tsserver_provider'
        if not utils.bufname_valid(vim.api.nvim_buf_get_name(bufnr)) then
          return
        end
        local root = utils.get_root_dir(bufnr)
        if provider.npm_global_path then
          return on_dir(root)
        end
        vim.api.nvim_buf_call(bufnr, function()
          provider.init(function()
            on_dir(root)
          end)
        end)
      end,
    },
  },
}

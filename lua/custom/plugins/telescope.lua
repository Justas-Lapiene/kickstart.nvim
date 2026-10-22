return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  branch = 'master',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    {
      'nvim-telescope/telescope-live-grep-args.nvim',
      version = '^1.0.0',
    },
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  config = function()
    require('telescope').setup {
      defaults = {
        file_ignore_patterns = { 'node_modules', '.git' },
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }

    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    local builtin = require 'telescope.builtin'
    local live_grep_args_shortcuts = require 'telescope-live-grep-args.shortcuts'
    vim.keymap.set('n', '<leader><leader>', function()
      builtin.find_files { hidden = true }
    end, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>/', function()
      require('telescope').extensions.live_grep_args.live_grep_args()
    end, { desc = 'Live grep with args' })
    vim.keymap.set('n', '<leader>/c', live_grep_args_shortcuts.grep_word_under_cursor, { desc = 'Grep word under cursor' })

    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim files' })
  end,
}

-- Set leader key before plugins are loaded
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- [[ Options ]]
vim.opt.clipboard = 'unnamedplus'
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand '~/.config/nvim/undo'
vim.opt.relativenumber = true
vim.opt.number = true

vim.opt.title = true
vim.opt.signcolumn = 'yes'
vim.opt.smartindent = true
-- Never show the "found a swap file" (E325) prompt: it cannot be answered from
-- inside a vim.schedule callback, which breaks LSP jumps into unopened buffers.
vim.opt.shortmess:append 'A'
vim.opt.cmdheight = 0
vim.opt.laststatus = 0
vim.opt.expandtab = true
vim.opt.inccommand = 'split'
vim.opt.ignorecase = true
vim.opt.breakindent = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.wrap = false
vim.opt.path:append { '**' }
vim.opt.wildignore:append { '*/node_modules/*' }
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitkeep = 'cursor'
vim.opt.scrolloff = 15
vim.opt.cursorline = true
vim.opt.cursorlineopt = 'number'
vim.opt.timeoutlen = 300
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold' }, {
  command = 'checktime',
})

-- [[ Keymaps ]]
local keymap = vim.keymap
local opts = { noremap = true, silent = true }
keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

keymap.set('n', '<leader>q', function()
  local in_diffview = package.loaded['diffview'] and require('diffview.lib').get_current_view() ~= nil
  vim.cmd(in_diffview and 'DiffviewClose' or 'quit')
end, { desc = 'Quit window, or close diffview' })
keymap.set('n', '<leader>w', '<cmd>write<cr>', { desc = 'Write' })
-- Select all
keymap.set('n', '<C-a>', 'gg<S-v>G')

-- Split window
keymap.set('n', 'ss', ':split<Return>', opts)
keymap.set('n', 'sv', ':vsplit<Return>', opts)

-- Typescript-tools
keymap.set('n', '<leader>cai', '<cmd>TSToolsAddMissingImports<cr>', { desc = 'Add missing imports' })
keymap.set('n', '<leader>crs', '<cmd>TSToolsRemoveUnused<cr>', { desc = 'Remove unused statements' })
keymap.set('n', '<leader>cri', '<cmd>TSToolsRemoveUnusedImports<cr>', { desc = 'Remove unused imports' })

--nvim surround
keymap.set('x', '(', 'S)', { remap = true })
keymap.set('x', ')', 'S)', { remap = true })
keymap.set('x', '[', 'S]', { remap = true })
keymap.set('x', ']', 'S]', { remap = true })
keymap.set('x', '{', 'S}', { remap = true })
keymap.set('x', '}', 'S}', { remap = true })

-- Key enhancements
keymap.set('n', '<C-u>', '<C-u>zz', opts)
keymap.set('n', '<C-d>', '<C-d>zz', opts)
keymap.set('v', 'J', ":m '>+1<CR>gv=gv", opts)
keymap.set('v', 'K', ":m '<-2<CR>gv=gv", opts)
keymap.set('n', 'n', 'nzzzv')
keymap.set('n', 'N', 'Nzzzv')
keymap.set('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
keymap.set('n', '<leader>e', function()
  local in_diffview = package.loaded['diffview'] and require('diffview.lib').get_current_view() ~= nil
  vim.cmd(in_diffview and 'DiffviewToggleFiles' or 'Neotree toggle')
end, { desc = 'Toggle file tree, or diffview file panel' })
keymap.set('n', '<leader>cc', '<cmd>ClaudeCode --continue<CR>', { desc = 'Toggle Claude Code' })
keymap.set('x', '<leader>cr', function()
  require('custom.inline-edit').edit_selection()
end, { desc = 'Rewrite selection with Claude' })

keymap.set('n', '<leader>dd', function()
  if vim.api.nvim_win_get_config(0).relative == '' then -- Not inside floating window
    vim.diagnostic.open_float() -- Open diagnostic in floating window
    vim.diagnostic.open_float() -- Another call jumps into the floating window
  else -- Inside a floating window
    vim.api.nvim_win_close(0, false) -- Or you can press "q" in the floating window
  end
end, { desc = '[t] Toggle diagnostic floating window' })

keymap.set('n', '<leader>z', ':ZenMode<CR>', opts)

keymap.set('n', '<leader>gb', '<cmd>GitBlameOpenCommitURL<CR>', opts)

-- [[ Basic Autocommands ]]
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- [[ Install lazy.nvim plugin manager ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
require('lazy').setup {
  'tpope/vim-sleuth',

  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      icons = { mappings = vim.g.have_nerd_font },
      spec = {
        { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = '[T]oggle' },
      },
    },
  },

  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luv types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      vim.diagnostic.config {
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = '',
            [vim.diagnostic.severity.WARN] = '',
            [vim.diagnostic.severity.INFO] = '',
            [vim.diagnostic.severity.HINT] = '',
          },
        },
        virtual_text = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      }

      -- LSP keymaps on attach
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('<leader>rr', function()
            local buf = vim.api.nvim_get_current_buf()
            local clients = vim.lsp.get_clients { bufnr = buf }
            vim.diagnostic.reset()
            for _, client in ipairs(clients) do
              if client.name ~= 'copilot' then
                client:stop()
              end
            end
            vim.defer_fn(function()
              vim.cmd 'edit!'
            end, 500)
          end, '[R]estart LSP')

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.name == 'copilot' then
            vim.lsp.inline_completion.enable(true, { bufnr = event.buf })
          end
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local hlgrp = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = hlgrp,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = hlgrp,
              callback = vim.lsp.buf.clear_references,
            })
            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(ev)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = ev.buf }
              end,
            })
          end

          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Capabilities shared by every server
      vim.lsp.config('*', {
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
      })

      -- Per-server configuration
      vim.lsp.config('lua_ls', {
        settings = { Lua = { completion = { callSnippet = 'Replace' } } },
      })

      local servers = { 'eslint', 'lua_ls', 'tailwindcss', 'cssls', 'cssmodules_ls', 'jsonls', 'bashls' }

      require('mason').setup()
      require('mason-tool-installer').setup { ensure_installed = { 'stylua', 'copilot-language-server' } }
      vim.lsp.enable 'copilot'
      require('mason-lspconfig').setup {
        ensure_installed = servers,
        -- stylua is a formatter run by conform; do not start it as an LSP server
        automatic_enable = { exclude = { 'stylua' } },
      }
    end,
  },

  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
      { '<leader>W', '<cmd>noautocmd write<CR>', mode = 'n', desc = 'Save without formatting' },
    },
    opts = {
      notify_on_error = true,
      format_on_save = { timeout_ms = 500, lsp_format = 'fallback' },
      formatters_by_ft = {
        lua = { 'stylua' },
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
      },
    },
  },

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function()
      local cmp = require 'cmp'

      cmp.setup {
        completion = { completeopt = 'menu,menuone,noinsert' },

        mapping = cmp.mapping.preset.insert {
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<CR>'] = cmp.mapping.confirm { select = true },
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif not vim.lsp.inline_completion.get() then
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
          ['<C-n>'] = cmp.mapping.complete {},
          ['<ESC>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.abort()
            else
              fallback()
            end
          end),
        },
        sources = {
          { name = 'lazydev', group_index = 0 },
          { name = 'nvim_lsp' },
          { name = 'path' },
        },
      }
    end,
  },

  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').install {
        'bash',
        'css',
        'html',
        'javascript',
        'json',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'tsx',
        'typescript',
        'vim',
        'vimdoc',
        'yaml',
      }

      -- Highlighting and indentation come from Neovim's built-in treesitter;
      -- the plugin only manages parsers and queries.
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('treesitter-start', { clear = true }),
        callback = function(event)
          if not pcall(vim.treesitter.start, event.buf) then
            return
          end
          vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },

  { import = 'custom.plugins' },
}

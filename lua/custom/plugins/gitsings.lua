return {
  'lewis6991/gitsigns.nvim',
  opts = {
    on_attach = function(bufnr)
      local gitsigns = require 'gitsigns'

      local function map(mode, lhs, rhs, options)
        options = options or {}
        options.buffer = bufnr
        vim.keymap.set(mode, lhs, rhs, options)
      end

      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal { ']c', bang = true }
        else
          gitsigns.nav_hunk 'next'
        end
        vim.cmd.normal { 'zz', bang = true }
      end, { desc = 'Jump to next git [c]hange' })

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal { '[c', bang = true }
        else
          gitsigns.nav_hunk 'prev'
        end
        vim.cmd.normal { 'zz', bang = true }
      end, { desc = 'Jump to previous git [c]hange' })
    end,
  },
}

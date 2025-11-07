return { -- You can easily change to a different colorscheme.
  -- Change the name of the colorscheme plugin below, and then
  -- change the command in the config to whatever the name of that colorscheme is.
  -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
  'Justas-Lapiene/neovim-ayu',
  config = function()
    local colors = require 'ayu.colors'
    colors.generate(false) -- Pass `true` to enable mirage

    require('ayu').setup {
      overrides = function()
        return {
          Normal = { bg = 'None' },
          NeoTreeGitModified = { fg = colors.func },
          MatchParen = { fg = colors.warning, bold = true },
          NeoTreeDirectoryName = { fg = colors.fg },
          LineNr = { fg = colors.fg },
          CursorLineNr = { fg = colors.func },
        }
      end,
    }
  end,
  priority = 1000, -- Make sure to load this before all the other start plugins.
  init = function()
    -- Load the colorscheme here.
    -- Like many other themes, this one has different styles, and you could load
    -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
    vim.cmd.colorscheme 'ayu'

    -- You can configure highlights by doing something like:
    -- vim.cmd.hi 'Comment gui=none'
  end,
}

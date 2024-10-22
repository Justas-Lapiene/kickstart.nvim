return {
  'Justas-Lapiene/neovim-ayu',
  config = function()
    local colors = require 'ayu.colors'
    colors.generate(false) -- Pass `true` to enable mirage

    require('ayu').setup {
      overrides = function()
        return {
          NeoTreeGitModified = { fg = colors.func },
          MatchParen = { fg = colors.warning, bold = true },
          NeoTreeDirectoryName = { fg = colors.fg },
          LineNr = { fg = colors.fg },
          CursorLineNr = { fg = colors.func },
        }
      end,
    }
  end,
}

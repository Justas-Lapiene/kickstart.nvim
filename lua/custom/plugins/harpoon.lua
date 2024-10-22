return {
  {
    'theprimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('harpoon'):setup()
      local wk = require 'which-key'
      wk.add {
        {
          '<leader>a',
          function()
            require('harpoon'):list():add()
          end,
          hidden = true,
        },
        {
          '<leader>h',
          function()
            local harpoon = require 'harpoon'
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          hidden = true,
        },
        {
          '<leader>1',
          function()
            require('harpoon'):list():select(1)
          end,
          hidden = true,
        },
        {
          '<leader>2',
          function()
            require('harpoon'):list():select(2)
          end,
          hidden = true,
        },
        {
          '<leader>3',
          function()
            require('harpoon'):list():select(3)
          end,
          hidden = true,
        },
        {
          '<leader>4',
          function()
            require('harpoon'):list():select(4)
          end,
          hidden = true,
        },
        {
          '<leader>5',
          function()
            require('harpoon'):list():select(5)
          end,
          hidden = true,
        },
        {
          '<leader>6',
          function()
            require('harpoon'):list():select(6)
          end,
          hidden = true,
        },
        {
          '<leader>7',
          function()
            require('harpoon'):list():select(7)
          end,
          hidden = true,
        },
        {
          '<leader>8',
          function()
            require('harpoon'):list():select(8)
          end,
          hidden = true,
        },
        {
          '<leader>9',
          function()
            require('harpoon'):list():select(9)
          end,
          hidden = true,
        },
      }
    end,
  },
}

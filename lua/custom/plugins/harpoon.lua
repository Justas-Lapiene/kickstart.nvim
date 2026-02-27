local function safe_select(n)
  local harpoon = require 'harpoon'
  local list = harpoon:list()
  local ok = pcall(list.select, list, n)
  if not ok then
    -- Buffer was opened but cursor restore failed (buffer not fully loaded).
    -- Set cursor once the buffer finishes reading from disk.
    local item = list.items[n]
    if item and item.context then
      vim.api.nvim_create_autocmd('BufReadPost', {
        once = true,
        callback = function()
          pcall(vim.api.nvim_win_set_cursor, 0, {
            item.context.row or 1,
            item.context.col or 0,
          })
        end,
      })
    end
  end
end

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
        { '<leader>1', function() safe_select(1) end, hidden = true },
        { '<leader>2', function() safe_select(2) end, hidden = true },
        { '<leader>3', function() safe_select(3) end, hidden = true },
        { '<leader>4', function() safe_select(4) end, hidden = true },
        { '<leader>5', function() safe_select(5) end, hidden = true },
        { '<leader>6', function() safe_select(6) end, hidden = true },
        { '<leader>7', function() safe_select(7) end, hidden = true },
        { '<leader>8', function() safe_select(8) end, hidden = true },
        { '<leader>9', function() safe_select(9) end, hidden = true },
      }
    end,
  },
}

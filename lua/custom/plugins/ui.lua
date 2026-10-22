return {
  { 'f-person/git-blame.nvim' },
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    commit = '9b5d67119c46e3262ffe1508fe6d8540b79ad75d',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    cmd = 'Neotree',
    keys = {
      { '\\', '<cmd>Neotree reveal<cr>', desc = 'Reveal file in Neo-tree' },
    },
    opts = {
      popup_border_style = 'rounded',
      -- Directories first, then files, dotfiles last within each group
      sort_function = function(first, second)
        local function is_dotfile(file)
          return file.path:match '^%.'
        end

        if is_dotfile(first) ~= is_dotfile(second) then
          return not is_dotfile(first)
        elseif first.type == second.type then
          return first.path < second.path
        else
          return first.type < second.type
        end
      end,
      window = {
        mappings = {
          ['l'] = 'open',
          ['h'] = 'close_node',
        },
      },
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        follow_current_file = { enabled = true },
      },
      buffers = {
        follow_current_file = { enabled = true },
      },
    },
  },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {},
    dependencies = {
      'MunifTanjim/nui.nvim',
      { 'rcarriga/nvim-notify', opts = { background_colour = '#000000' } },
    },
  },
}

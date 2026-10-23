return {
  'mrjones2014/smart-splits.nvim',
  lazy = false,
  opts = {
    ignored_buftypes = { 'prompt' },
    ignored_filetypes = {},
    move = { at_edge = 'stop' },
  },
  keys = {
    {
      '<c-h>',
      function()
        require('smart-splits').move_cursor_left()
      end,
    },
    {
      '<c-j>',
      function()
        require('smart-splits').move_cursor_down()
      end,
    },
    {
      '<c-k>',
      function()
        require('smart-splits').move_cursor_up()
      end,
    },
    {
      '<c-l>',
      function()
        require('smart-splits').move_cursor_right()
      end,
    },
    {
      '<c-\\>',
      function()
        require('smart-splits').move_cursor_previous()
      end,
    },
  },
}

return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  dependencies = { 'hrsh7th/nvim-cmp' },
  config = function()
    require('nvim-autopairs').setup {}
    -- Automatically add `(` after selecting a function or method
    local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
    require('cmp').event:on('confirm_done', cmp_autopairs.on_confirm_done())
  end,
}

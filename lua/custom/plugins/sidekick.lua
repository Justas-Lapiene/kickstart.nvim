return {
  'folke/sidekick.nvim',
  event = 'VeryLazy',
  opts = {
    nes = { enabled = true },
    cli = { mux = { enabled = false } },
  },
  keys = {
    {
      '<Tab>',
      function()
        if not require('sidekick').nes_jump_or_apply() then
          return '<Tab>'
        end
      end,
      mode = 'n',
      expr = true,
      desc = 'Jump to or apply next edit suggestion',
    },
  },
}

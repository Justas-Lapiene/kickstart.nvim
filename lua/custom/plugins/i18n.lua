return {
  'nabekou29/js-i18n.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-lua/plenary.nvim',
    'hrsh7th/nvim-cmp',
  },
  event = 'VeryLazy',
  opts = {
    -- Primary locale used as reference for missing keys
    primary_locale = { 'en' },
    -- Directory where translation files are stored (relative to project root)
    locales_dir = { 'public/locales' },
    -- nvim-cmp integration
    cmp = {
      enabled = true,
    },
    -- Virtual text showing translation values
    vt = {
      enabled = true,
      max_width = 80,
    },
  },
}

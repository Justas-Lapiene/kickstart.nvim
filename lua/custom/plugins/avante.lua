return {
  'yetone/avante.nvim',
  event = 'VeryLazy',
  build = 'make', -- ensure make is available; if build fails, install make or remove this line
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'nvim-tree/nvim-web-devicons', -- optional, for icons
    'stevearc/dressing.nvim', -- optional, nicer UI prompts
  },
  opts = {
    provider = 'openai', -- or "anthropic", "openrouter", "ollama"
    model = 'gpt-4o-mini', -- change per provider (see examples below)
  },
}

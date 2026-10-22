return {
  'coder/claudecode.nvim',
  dependencies = { 'folke/snacks.nvim' },
  opts = {
    terminal = {
      provider = 'external',
      provider_opts = {
        external_terminal_cmd = function(cmd, env)
          local args = { 'kitten', '@', 'launch', '--type=window', '--location=vsplit', '--bias=30', '--cwd=current' }
          table.insert(args, '--env')
          table.insert(args, 'PATH=' .. vim.env.PATH)
          for key, value in pairs(env) do
            table.insert(args, '--env')
            table.insert(args, key .. '=' .. value)
          end
          table.insert(args, 'sh')
          table.insert(args, '-c')
          table.insert(args, cmd)
          vim.fn.system(args)
          return 'true'
        end,
      },
    },
  },
  keys = {
    { '<leader>cc', '<cmd>ClaudeCode --continue<cr>', desc = 'Toggle Claude' },
    { '<leader>cf', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude' },
    -- { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
    -- { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
    -- { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
    { '<leader>ca', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add current buffer' },
    { '<leader>cs', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send to Claude' },
    {
      '<leader>as',
      '<cmd>ClaudeCodeTreeAdd<cr>',
      desc = 'Add file',
      ft = { 'NvimTree', 'neo-tree', 'oil', 'minifiles', 'netrw' },
    },
    -- Diff management
    { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
    { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny diff' },
  },
}

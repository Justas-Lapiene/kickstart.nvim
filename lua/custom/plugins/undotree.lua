return {
  'mbbill/undotree',
  keys = {
    {
      '<leader>u',
      function()
        vim.cmd.UndotreeToggle()
        vim.cmd.UndotreeFocus()
      end,
      desc = 'Toggle [U]ndotree',
    },
  },
  init = function()
    vim.g.undotree_WindowLayout = 3
    vim.g.undotree_SetFocusWhenToggle = 1
  end,
}

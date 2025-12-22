return {
  {
    'mbbill/undotree',
    enabled = false,
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      vim.g.undotree_WindowLayout = 2
      vim.g.undotree_SplitWidth = 45
      vim.g.undotree_SetFocusWhenToggle = 1

      if vim.fn.has 'win32' or vim.fkn.has 'win64' then
        vim.g.undotree_DiffCommand = 'git diff'
      end

      vim.keymap.set('n', '<leader>tu', vim.cmd.UndotreeToggle, { desc = 'UndoTree' })
    end,
  },
}

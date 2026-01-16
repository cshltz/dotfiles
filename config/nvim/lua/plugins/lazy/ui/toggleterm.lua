return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    enabled = false,
    event = 'VeryLazy',
    opts = {
      direction = 'vertical',
      size = vim.o.columns * 0.6,
      open_mapping = [[<leader>tt]],
      insert_mappings = false,
      shell = 'pwsh',
    },
  },
}

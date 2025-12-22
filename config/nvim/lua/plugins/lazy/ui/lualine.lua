return {
  {
    'nvim-lualine/lualine.nvim',
    enabled = true,
    event = { 'BufReadPre', 'BufNewFile' },
    config = true,
    options = {
      theme = 'auto',
    },
  },
}

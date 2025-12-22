return {
  'folke/tokyonight.nvim',
  enabled = false,
  lazy = false,
  priority = 1000,
  opts = {
    style = 'storm',
    styles = {
      functions = {},
    },
  },
  init = function()
    vim.cmd.hi 'Comment gui=none'
    vim.cmd 'colorscheme tokyonight'
  end,
}

vim.pack.add({ 'https://github.com/cshltz/gentlenight.nvim' })

require('gentlenight').setup({
  style = 'dusk',
})

vim.cmd.hi 'Comment gui=none'
vim.cmd 'colorscheme gentlenight'

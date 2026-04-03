vim.pack.add({ 'https://github.com/L3MON4D3/LuaSnip' })
vim.pack.add({ 'https://github.com/rafamadriz/friendly-snippets' })

if vim.fn.has 'win32' == 0 and vim.fn.executable 'make' == 1 then
  vim.cmd 'Make install_jsregexp'
end

require('luasnip.loaders.from_vscode').lazy_load()

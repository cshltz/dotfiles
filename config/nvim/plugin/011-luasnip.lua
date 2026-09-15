local pack_hooks = require 'pack-hooks'

pack_hooks.hooks.LuaSnip = function(ev)
  if vim.fn.has 'win32' == 0 and vim.fn.executable 'make' == 1 then
    pack_hooks.run_build('LuaSnip', { 'make', 'install_jsregexp' }, ev.data.path)
  end
end

vim.pack.add { { src = 'https://github.com/L3MON4D3/LuaSnip', version = vim.version.range '2.*' } }
require('luasnip').setup {}

vim.pack.add { 'https://github.com/rafamadriz/friendly-snippets' }
require('luasnip.loaders.from_vscode').lazy_load()

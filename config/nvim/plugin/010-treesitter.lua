vim.pack.add({ 'https://github.com/nvim-treesitter/nvim-treesitter' })
vim.pack.add({ 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects' })

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind
    if name == 'nvim-treesitter' and kind == 'update' then
      if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
      vim.cmd('TSUpdate')
    end
  end,
})

local parsers = {
  'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown',
  'markdown_inline', 'query', 'vim', 'vimdoc', 'c_sharp', 'powershell',
}

local no_i_parsers = { 'c_sharp' }

local function treesitter_try_attach(buf, language)
  if not vim.treesitter.language.add(language) then
    return
  end
  vim.treesitter.start(buf, language)
  vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  if not vim.tbl_contains(no_i_parsers, language) then
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
end

vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local buf, filetype = args.buf, args.match
    local language = vim.treesitter.language.get_lang(filetype)
    if not language then return end

    local installed_parsers = require('nvim-treesitter').get_installed 'parsers'
    if vim.tbl_contains(installed_parsers, language) then
      treesitter_try_attach(buf, language)
    elseif vim.tbl_contains(require('nvim-treesitter').get_available(), language) then
      require('nvim-treesitter').install(language):await(function()
        treesitter_try_attach(buf, language)
      end)
    else
      treesitter_try_attach(buf, language)
    end
  end,
})

require('nvim-treesitter').install(parsers)

vim.g.no_plugin_maps = true
require('nvim-treesitter-textobjects').setup({
  lookahead = true,
  selection_modes = {
    ['@parameter.outer'] = 'v',
    ['@function.outer'] = 'V',
  },
  include_surrounding_whitespace = false,
})

local tsselect = require 'nvim-treesitter-textobjects.select'
vim.keymap.set({ 'x', 'o' }, 'am', function()
  tsselect.select_textobject('@function.outer', 'textobjects')
end, { desc = 'method' })
vim.keymap.set({ 'x', 'o' }, 'im', function()
  tsselect.select_textobject('@function.inner', 'textobjects')
end, { desc = 'method' })
vim.keymap.set({ 'x', 'o' }, 'ac', function()
  tsselect.select_textobject('@class.outer', 'textobjects')
end, { desc = 'class' })
vim.keymap.set({ 'x', 'o' }, 'ic', function()
  tsselect.select_textobject('@class.inner', 'textobjects')
end, { desc = 'class' })
vim.keymap.set({ 'x', 'o' }, 'as', function()
  tsselect.select_textobject('@local.scope', 'locals')
end, { desc = 'scope' })

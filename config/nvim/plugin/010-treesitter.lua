vim.pack.add { 'https://github.com/nvim-treesitter/nvim-treesitter' }
vim.pack.add { 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects' }

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind
    if name == 'nvim-treesitter' and kind == 'update' then
      if not ev.data.active then
        vim.cmd.packadd 'nvim-treesitter'
      end
      vim.cmd 'TSUpdate'
    end
  end,
})

local parsers = {
  'bash',
  'c',
  'diff',
  'html',
  'lua',
  'luadoc',
  'markdown',
  'markdown_inline',
  'query',
  'vim',
  'vimdoc',
  'c_sharp',
  'powershell',
  'python',
}

local no_i_parsers = { 'c_sharp' }

local treesitter_runtime = vim.fs.joinpath(vim.fn.stdpath 'data', 'site/pack/core/opt/nvim-treesitter/runtime')
vim.opt.rtp:prepend(treesitter_runtime)

vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    vim.cmd.packadd 'nvim-treesitter'
    local ok, ts = pcall(require, 'nvim-treesitter')
    if ok then
      ts.install(parsers)
    end
  end,
})

local function treesitter_try_attach(buf, language)
  vim.cmd.packadd 'nvim-treesitter'
  vim.cmd.packadd 'nvim-treesitter-textobjects'

  if not vim.treesitter.language.add(language) then
    return
  end

  vim.treesitter.start(buf, language)
  vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  if not vim.tbl_contains(no_i_parsers, language) then
    vim.bo.indentexpr = 'v:lua.vim.treesitter.indentexpr(buf)'
  end
end

vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local buf, filetype = args.buf, args.match
    local language = vim.treesitter.language.get_lang(filetype)
    if not language then
      return
    end
    treesitter_try_attach(buf, language)
  end,
})

vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    vim.cmd.packadd 'nvim-treesitter-textobjects'
    vim.g.no_plugin_maps = true
    require('nvim-treesitter-textobjects').setup {
      lookahead = true,
      selection_modes = {
        ['@parameter.outer'] = 'v',
        ['@function.outer'] = 'V',
      },
      include_surrounding_whitespace = false,
    }

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
  end,
})

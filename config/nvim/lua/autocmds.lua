--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('nice-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd({ 'VimLeavePre' }, {
  group = vim.api.nvim_create_augroup('fuck_shada_temp', { clear = true }),
  pattern = { '*' },
  callback = function()
    local status = 0
    for _, f in ipairs(vim.fn.globpath(vim.fn.stdpath 'data' .. '/shada', '*tmp*', false, true)) do
      if vim.tbl_isempty(vim.fn.readfile(f)) then
        status = status + vim.fn.delete(f)
      end
    end
    if status ~= 0 then
      vim.notify('Could not delete empty temporary ShaDa files.', vim.log.levels.ERROR)
      vim.fn.getchar()
    end
  end,
  desc = 'Delete empty temp ShaDa files',
})

-- vim: ts=2 sts=2 sw=2 et

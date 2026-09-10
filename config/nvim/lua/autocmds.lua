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

local logfile = vim.fs.joinpath(vim.fn.stdpath 'cache', 'lsp-stop.log')
local match = 'easy_dotnet' -- set to nil to log every LSP client

local function tracked(name)
  return not match or name:find(match, 1, true) ~= nil
end

local function log(msg)
  vim.fn.writefile(vim.split(('[%s] %s'):format(os.date '%H:%M:%S', msg), '\n'), logfile, 'a')
end

-- Who starts clients?
local orig_start = vim.lsp.start
vim.lsp.start = function(config, opts)
  if config and config.name and tracked(config.name) then
    log(('START   %s root=%s\n%s\n'):format(config.name, tostring(config.root_dir), debug.traceback('', 2)))
  end
  return orig_start(config, opts)
end

-- Who stops them? (the interesting one -- nvim installs stop() per instance,
-- so hook each client as it attaches)
local hooked = {}
vim.api.nvim_create_autocmd({ 'LspAttach', 'LspDetach' }, {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or not tracked(client.name) then
      return
    end

    log(('%-7s %s id=%d root=%s buf=%s'):format(args.event == 'LspAttach' and 'ATTACH' or 'DETACH', client.name, client.id, tostring(client.root_dir), vim.api.nvim_buf_get_name(args.buf)))

    if not hooked[client.id] then
      hooked[client.id] = true
      local orig_stop = client.stop
      client.stop = function(self, force)
        log(('STOP    %s id=%d force=%s\n%s\n'):format(client.name, client.id, tostring(force), debug.traceback('', 2)))
        return orig_stop(self, force)
      end
    end
  end,
})

vim.notify('easy-dotnet LSP start/stop logging -> ' .. logfile)
-- vim: ts=2 sts=2 sw=2 et

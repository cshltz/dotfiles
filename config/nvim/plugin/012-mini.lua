vim.pack.add { 'https://github.com/nvim-mini/mini.ai' }
require('mini.ai').setup {
  n_lines = 500,
}

vim.pack.add { 'https://github.com/nvim-mini/mini.surround' }
require('mini.surround').setup {}

vim.pack.add { 'https://github.com/nvim-mini/mini.icons' }
require('mini.icons').setup {
  file = {
    ['.keep'] = { glyph = '󰊢', hl = 'MiniIconsGrey' },
    ['devcontainer.json'] = { glyph = '', hl = 'MiniIconsAzure' },
  },
  filetype = {
    dotenv = { glyph = '', hl = 'MiniIconsYellow' },
  },
}
package.preload['nvim-web-devicons'] = function()
  require('mini.icons').mock_nvim_web_devicons()
  return package.loaded['nvim-web-devicons']
end

vim.pack.add { 'https://github.com/nvim-mini/mini.starter' }
vim.pack.add { 'https://github.com/nvim-mini/mini.pick' }
vim.pack.add { 'https://github.com/nvim-mini/mini.pairs' }
vim.pack.add { 'https://github.com/nvim-mini/mini.extra' }
vim.pack.add { 'https://github.com/nvim-mini/mini.files' }
vim.pack.add { 'https://github.com/nvim-mini/mini.notify' }
vim.pack.add { 'https://github.com/nvim-mini/mini.indentscope' }

require('mini.starter').setup {}
require('mini.pick').setup {
  window = { config = { border = 'rounded' } },
}
require('mini.pairs').setup {}
require('mini.extra').setup {}
require('mini.files').setup {
  windows = {
    preview = true,
    width_preview = 75,
    width_focus = 50,
    width_nofocus = 15,
  },
}
require('mini.notify').setup {}
require('mini.indentscope').setup {}

local MiniPick = require 'mini.pick'
local MiniExtra = require 'mini.extra'
local MiniFiles = require 'mini.files'
local MiniNotify = require 'mini.notify'

vim.notify = MiniNotify.make_notify {
  ERROR = { duration = 3000 },
  WARN = { duration = 3000 },
  INFO = { duration = 3000 },
}

-- List files (including hidden, excluding .git) using the best available CLI tool
local function list_files_items()
  local cmd
  if vim.fn.executable 'rg' == 1 then
    cmd = { 'rg', '--files', '--hidden', '--glob', '!.git' }
  elseif vim.fn.executable 'fd' == 1 then
    cmd = { 'fd', '--type', 'f', '--hidden', '--exclude', '.git' }
  end
  if not cmd then
    return nil
  end
  local lines = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 or #lines == 0 then
    return nil
  end
  return lines
end

local function pick_files()
  local items = list_files_items()
  if not items then
    return MiniPick.builtin.files()
  end
  return MiniPick.start {
    source = { name = 'Files', items = items },
  }
end

local function pick_smart()
  vim.fn.systemlist { 'git', 'rev-parse', '--is-inside-work-tree' }
  if vim.v.shell_error == 0 then
    return MiniExtra.pickers.git_files()
  end
  return pick_files()
end

local function grep_word(word)
  if word == nil or word == '' then
    return
  end
  return MiniPick.builtin.grep { pattern = word }
end

local function rename_file()
  local old = vim.api.nvim_buf_get_name(0)
  if old == '' then
    vim.notify('Current buffer has no file name', vim.log.levels.WARN)
    return
  end
  local new = vim.fn.input('Rename to: ', old, 'file')
  if new == '' or new == old then
    return
  end
  vim.fn.mkdir(vim.fn.fnamemodify(new, ':h'), 'p')
  if vim.uv.fs_rename(old, new) then
    vim.api.nvim_buf_set_name(0, new)
    vim.cmd 'silent! edit'
    vim.notify('Renamed to ' .. new)
  else
    vim.notify('Rename failed: ' .. new, vim.log.levels.ERROR)
  end
end

local function pick_notifications()
  local notifs = vim.tbl_values(MiniNotify.get_all())
  table.sort(notifs, function(a, b)
    return (a.ts_update or 0) > (b.ts_update or 0)
  end)
  local items = {}
  for _, n in ipairs(notifs) do
    items[#items + 1] = ('[%s] %s'):format(n.level or 'INFO', (n.msg or ''):gsub('\n', ' '))
  end
  return MiniPick.start {
    source = { name = 'Notifications', items = items },
  }
end

-- Search
vim.keymap.set('n', '<leader><space>', pick_smart, { desc = 'Smart Find Files' })
vim.keymap.set('n', '<leader>:', function()
  MiniExtra.pickers.history { scope = ':' }
end, { desc = 'Command History' })

vim.keymap.set('n', '<leader>sf', pick_files, { desc = 'Files' })
vim.keymap.set('n', '<leader>sb', function()
  MiniExtra.pickers.buf_lines()
end, { desc = 'Buffer Lines' })
vim.keymap.set({ 'n', 'x' }, '<leader>sg', function()
  MiniPick.builtin.grep_live()
end, { desc = 'Grep' })
vim.keymap.set('n', '<leader>sw', function()
  grep_word(vim.fn.expand '<cword>')
end, { desc = 'Word' })
vim.keymap.set('x', '<leader>sw', function()
  local region = vim.fn.getregion(vim.fn.getpos 'v', vim.fn.getpos '.', { type = vim.fn.visualmode() })
  grep_word(table.concat(region, ' '))
end, { desc = 'Word' })
vim.keymap.set('n', '<leader>s"', function()
  MiniExtra.pickers.registers()
end, { desc = 'Registers' })
vim.keymap.set('n', '<leader>s/', function()
  MiniExtra.pickers.history { scope = '/' }
end, { desc = 'Search History' })
vim.keymap.set('n', '<leader>sc', function()
  MiniExtra.pickers.history { scope = ':' }
end, { desc = 'Command History' })
vim.keymap.set('n', '<leader>sC', function()
  MiniExtra.pickers.commands()
end, { desc = 'Commands' })
vim.keymap.set('n', '<leader>sD', function()
  MiniExtra.pickers.diagnostic { scope = 'all' }
end, { desc = 'Global Diagnostics' })
vim.keymap.set('n', '<leader>sd', function()
  MiniExtra.pickers.diagnostic { scope = 'current' }
end, { desc = 'Buffer Diagnostics' })
vim.keymap.set('n', '<leader>sh', function()
  MiniPick.builtin.help()
end, { desc = 'Help Pages' })
vim.keymap.set('n', '<leader>sH', function()
  MiniExtra.pickers.hl_groups()
end, { desc = 'Highlights' })
vim.keymap.set('n', '<leader>sj', function()
  MiniExtra.pickers.list { scope = 'jump' }
end, { desc = 'Jumps' })
vim.keymap.set('n', '<leader>sk', function()
  MiniExtra.pickers.keymaps()
end, { desc = 'Keymaps' })
vim.keymap.set('n', '<leader>sl', function()
  MiniExtra.pickers.list { scope = 'location' }
end, { desc = 'Location List' })
vim.keymap.set('n', '<leader>sm', function()
  MiniExtra.pickers.marks()
end, { desc = 'Marks' })
vim.keymap.set('n', '<leader>sM', function()
  MiniExtra.pickers.manpages()
end, { desc = 'Man Pages' })
vim.keymap.set('n', '<leader>sq', function()
  MiniExtra.pickers.list { scope = 'quickfix' }
end, { desc = 'Quickfix List' })
vim.keymap.set('n', '<leader>sR', function()
  MiniPick.builtin.resume()
end, { desc = 'Resume' })
vim.keymap.set('n', '<leader>ss', function()
  MiniExtra.pickers.lsp { scope = 'document_symbol' }
end, { desc = 'LSP Symbols' })
vim.keymap.set('n', '<leader>sS', function()
  MiniExtra.pickers.lsp { scope = 'workspace_symbol_live' }
end, { desc = 'LSP Workspace Symbols' })

-- Open
vim.keymap.set('n', '<leader>oe', function()
  local path = vim.api.nvim_buf_get_name(0)
  if path ~= '' and vim.uv.fs_stat(path) then
    MiniFiles.open(path)
  else
    MiniFiles.open()
  end
end, { desc = 'Explorer' })

-- General / LSP
vim.keymap.set('n', '<leader>gd', function()
  MiniExtra.pickers.lsp { scope = 'definition' }
end, { desc = 'Goto Definition' })
vim.keymap.set('n', '<leader>gD', function()
  MiniExtra.pickers.lsp { scope = 'declaration' }
end, { desc = 'Goto Declaration' })
vim.keymap.set('n', '<leader>gr', function()
  MiniExtra.pickers.lsp { scope = 'references' }
end, { nowait = true, desc = 'References' })
vim.keymap.set('n', '<leader>gi', function()
  MiniExtra.pickers.lsp { scope = 'implementation' }
end, { desc = 'Goto Implementation' })
vim.keymap.set('n', '<leader>gy', function()
  MiniExtra.pickers.lsp { scope = 'type_definition' }
end, { desc = 'Goto Type Definition' })
vim.keymap.set('n', '<leader>gN', rename_file, { desc = 'Rename File' })
vim.keymap.set('n', '<leader>gci', function()
  vim.lsp.buf.incoming_calls()
end, { desc = 'Goto Incoming Calls' })
vim.keymap.set('n', '<leader>gco', function()
  vim.lsp.buf.outgoing_calls()
end, { desc = 'Goto Outgoing Calls' })

-- Notifications
vim.keymap.set('n', '<leader>Nn', pick_notifications, { desc = 'Notifications' })
vim.keymap.set('n', '<leader>Nh', function()
  MiniNotify.show_history()
end, { desc = 'Notification History' })
vim.keymap.set('n', '<leader>Nd', function()
  MiniNotify.clear()
end, { desc = 'Dismiss All Notifications' })

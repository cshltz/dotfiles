vim.pack.add { 'https://github.com/folke/snacks.nvim' }

require('snacks').setup {
  explorer = {},
  picker = {
    hidden = true,
    win = {
      input = {
        keys = {
          ['<a-j>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
          ['<a-k>'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
          ['<c-b>'] = { 'list_scroll_down', mode = { 'i', 'n' } },
        },
      },
    },
    sources = {
      files = { hidden = true },
      explorer = {
        auto_close = true,
        layout = { preset = 'default' },
        win = {
          list = {
            keys = {
              ['A'] = 'explorer_add_dotnet',
            },
          },
        },
        actions = {
          explorer_add_dotnet = function(picker)
            local dir = picker:dir()
            local easydotnet = require 'easy-dotnet'
            easydotnet.create_new_item(dir, function(item_path)
              local tree = require 'snacks.explorer.tree'
              local actions = require 'snacks.explorer.actions'
              tree:open(dir)
              tree:refresh(dir)
              actions.update(picker, { target = item_path })
              picker:focus()
            end)
          end,
        },
      },
    },
  },
  notifier = { timeout = 3000, wrap = true },
  dashboard = {
    sections = {
      { section = 'header' },
      { icon = ' ', title = 'Keymaps', section = 'keys', indent = 2, padding = 1 },
      { icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
      { icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
    },
  },
  lazygit = { start_insert = true },
  indent = {},
  scope = {},
  toggle = {},
  bigfile = {},
  input = {},
  quickfile = {},
  layout = {},
  terminal = {
    shell = 'pwsh',
    start_insert = false,
    auto_insert = false,
    win = {
      keys = {
        term_normal = {
          '`',
          function(self)
            self.esc_timer = self.esc_timer or (vim.uv or vim.loop).new_timer()
            if self.esc_timer:is_active() then
              self.esc_timer:stop()
              vim.cmd 'stopinsert'
            else
              local chan = vim.bo.channel
              self.esc_timer:start(200, 0, function()
                vim.schedule(function()
                  vim.api.nvim_chan_send(chan, '`')
                end)
              end)
            end
          end,
          mode = 't',
          expr = true,
          desc = 'Double backtick to normal mode',
        },
      },
    },
  },
  statuscolumn = {},
  words = {},
  styles = {
    notification = { wo = { wrap = true } },
    terminal = { width = 0.4, position = 'right' },
    lazygit = { width = 0.8 },
  },
}

vim.keymap.set('n', '<leader><space>', function()
  Snacks.picker.smart()
end, { desc = 'Smart Find Files' })
vim.keymap.set('n', '<leader>:', function()
  Snacks.picker.command_history()
end, { desc = 'Command History' })
vim.keymap.set('n', '<leader>oe', function()
  Snacks.explorer.reveal()
end, { desc = 'Explorer' })

vim.keymap.set('n', '<leader>fb', function()
  Snacks.picker.buffers()
end, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>fc', function()
  Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
end, { desc = 'Find Config File' })
vim.keymap.set('n', '<leader>fg', function()
  Snacks.picker.git_files()
end, { desc = 'Find Git Files' })
vim.keymap.set('n', '<leader>fp', function()
  Snacks.picker.projects()
end, { desc = 'Projects' })
vim.keymap.set('n', '<leader>fr', function()
  Snacks.picker.recent()
end, { desc = 'Recent' })
vim.keymap.set('n', '<leader>fC', function()
  Snacks.picker.colorschemes()
end, { desc = 'Colorschemes' })

vim.keymap.set('n', '<leader>sf', function()
  Snacks.picker.files()
end, { desc = 'Files' })
vim.keymap.set('n', '<leader>sb', function()
  Snacks.picker.lines()
end, { desc = 'Buffer Lines' })
vim.keymap.set('n', '<leader>sB', function()
  Snacks.picker.grep_buffers()
end, { desc = 'Grep Open Buffers' })
vim.keymap.set('n', '<leader>sg', function()
  Snacks.picker.grep()
end, { desc = 'Grep' })
vim.keymap.set({ 'n', 'x' }, '<leader>sw', function()
  Snacks.picker.grep_word()
end, { desc = 'Word' })
vim.keymap.set('n', '<leader>s"', function()
  Snacks.picker.registers()
end, { desc = 'Registers' })
vim.keymap.set('n', '<leader>s/', function()
  Snacks.picker.search_history()
end, { desc = 'Search History' })
vim.keymap.set('n', '<leader>sa', function()
  Snacks.picker.autocmds()
end, { desc = 'Autocmds' })
vim.keymap.set('n', '<leader>sc', function()
  Snacks.picker.command_history()
end, { desc = 'Command History' })
vim.keymap.set('n', '<leader>sC', function()
  Snacks.picker.commands()
end, { desc = 'Commands' })
vim.keymap.set('n', '<leader>sD', function()
  Snacks.picker.diagnostics()
end, { desc = 'Global Diagnostics' })
vim.keymap.set('n', '<leader>sd', function()
  Snacks.picker.diagnostics_buffer()
end, { desc = 'Buffer Diagnostics' })
vim.keymap.set('n', '<leader>sh', function()
  Snacks.picker.help()
end, { desc = 'Help Pages' })
vim.keymap.set('n', '<leader>sH', function()
  Snacks.picker.highlights()
end, { desc = 'Highlights' })
vim.keymap.set('n', '<leader>si', function()
  Snacks.picker.icons()
end, { desc = 'Icons' })
vim.keymap.set('n', '<leader>sj', function()
  Snacks.picker.jumps()
end, { desc = 'Jumps' })
vim.keymap.set('n', '<leader>sk', function()
  Snacks.picker.keymaps()
end, { desc = 'Keymaps' })
vim.keymap.set('n', '<leader>sl', function()
  Snacks.picker.loclist()
end, { desc = 'Location List' })
vim.keymap.set('n', '<leader>sm', function()
  Snacks.picker.marks()
end, { desc = 'Marks' })
vim.keymap.set('n', '<leader>sM', function()
  Snacks.picker.man()
end, { desc = 'Man Pages' })
vim.keymap.set('n', '<leader>sq', function()
  Snacks.picker.qflist()
end, { desc = 'Quickfix List' })
vim.keymap.set('n', '<leader>sR', function()
  Snacks.picker.resume()
end, { desc = 'Resume' })
vim.keymap.set('n', '<leader>su', function()
  Snacks.picker.undo()
end, { desc = 'Undo History' })

vim.keymap.set('n', '<leader>gd', function()
  Snacks.picker.lsp_definitions()
end, { desc = 'Goto Definition' })
vim.keymap.set('n', '<leader>gD', function()
  Snacks.picker.lsp_declarations()
end, { desc = 'Goto Declaration' })
vim.keymap.set('n', '<leader>gr', function()
  Snacks.picker.lsp_references()
end, { nowait = true, desc = 'References' })
vim.keymap.set('n', '<leader>gi', function()
  Snacks.picker.lsp_implementations()
end, { desc = 'Goto Implementation' })
vim.keymap.set('n', '<leader>gy', function()
  Snacks.picker.lsp_type_definitions()
end, { desc = 'Goto Type Definition' })
vim.keymap.set('n', '<leader>gN', function()
  Snacks.rename.rename_file()
end, { desc = 'Rename File' })
vim.keymap.set('n', '<leader>gci', function()
  Snacks.picker.lsp_incoming_calls()
end, { desc = 'Goto Incoming Calls' })
vim.keymap.set('n', '<leader>gco', function()
  Snacks.picker.lsp_outgoing_calls()
end, { desc = 'Goto Outgoing Calls' })

vim.keymap.set('n', '<leader>ss', function()
  Snacks.picker.lsp_symbols()
end, { desc = 'LSP Symbols' })
vim.keymap.set('n', '<leader>sS', function()
  Snacks.picker.lsp_workspace_symbols()
end, { desc = 'LSP Workspace Symbols' })

vim.keymap.set('n', '<leader>Gb', function()
  Snacks.picker.git_branches()
end, { desc = 'Git Branches' })
vim.keymap.set('n', '<leader>GL', function()
  Snacks.picker.git_log_line()
end, { desc = 'Git Log Line' })
vim.keymap.set('n', '<leader>Gd', function()
  Snacks.picker.git_diff()
end, { desc = 'Git Diff (Hunks)' })
vim.keymap.set({ 'n', 'v' }, '<leader>GB', function()
  Snacks.gitbrowse()
end, { desc = 'Git Browse' })

vim.keymap.set('n', '<leader>Ghi', function()
  Snacks.picker.gh_issue()
end, { desc = 'GitHub Issues (open)' })
vim.keymap.set('n', '<leader>GhI', function()
  Snacks.picker.gh_issue { state = 'all' }
end, { desc = 'GitHub Issues (all)' })
vim.keymap.set('n', '<leader>Ghp', function()
  Snacks.picker.gh_pr()
end, { desc = 'GitHub Pull Requests (open)' })
vim.keymap.set('n', '<leader>GhP', function()
  Snacks.picker.gh_pr { state = 'all' }
end, { desc = 'GitHub Pull Requests (all)' })

vim.keymap.set('n', '<leader>.', function()
  Snacks.scratch()
end, { desc = 'Toggle Scratch Buffer' })
vim.keymap.set('n', '<leader>S', function()
  Snacks.scratch.select()
end, { desc = 'Select Scratch Buffer' })
vim.keymap.set('n', '<leader>bfd', function()
  Snacks.bufdelete()
end, { desc = 'Delete Buffer' })

vim.keymap.set('n', '<leader>og', function()
  Snacks.lazygit()
end, { desc = 'Lazygit' })

vim.keymap.set('n', '<leader>tt', function()
  Snacks.terminal.toggle()
end, { desc = 'Terminal' })
vim.keymap.set('n', '<leader>ta', function()
  Snacks.terminal.toggle 'opencode'
end, { desc = 'Agent' })
vim.keymap.set('n', '<leader>tc', function()
  Snacks.terminal.toggle 'copilot'
end, { desc = 'Copilot' })

vim.keymap.set({ 'n', 't' }, ']]', function()
  Snacks.words.jump(vim.v.count1)
end, { desc = 'Next Reference' })
vim.keymap.set({ 'n', 't' }, '[[', function()
  Snacks.words.jump(-vim.v.count1)
end, { desc = 'Prev Reference' })

vim.keymap.set('n', '<leader>Nn', function()
  Snacks.picker.notifications()
end, { desc = 'Notifications' })
vim.keymap.set('n', '<leader>Nh', function()
  Snacks.notifier.show_history()
end, { desc = 'Notification History' })
vim.keymap.set('n', '<leader>Nd', function()
  Snacks.notifier.hide()
end, { desc = 'Dismiss All Notifications' })

Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>tus'
Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>tuw'
Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map '<leader>tuL'
Snacks.toggle.diagnostics():map '<leader>tud'
Snacks.toggle.line_number():map '<leader>tul'
Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map '<leader>tuc'
Snacks.toggle.treesitter():map '<leader>tuT'
Snacks.toggle.inlay_hints():map '<leader>tuh'
Snacks.toggle.indent():map '<leader>tug'
Snacks.toggle.dim():map '<leader>tuD'

local function walk_in_codediff(picker, item)
  picker:close()
  if item.commit then
    local current_commit = item.commit
    vim.fn.setreg('+', current_commit)
    vim.notify('Copied: ' .. current_commit)
    local parent_commit = vim.trim(vim.fn.system('git rev-parse --short ' .. current_commit .. '^'))
    parent_commit = parent_commit:match '[a-f0-9]+'
    if vim.v.shell_error ~= 0 then
      vim.notify('Cannot find parent (Root commit?)', vim.log.levels.WARN)
      parent_commit = ''
    end
    local cmd = string.format('CodeDiff %s %s', parent_commit, current_commit)
    vim.notify('Diffing: ' .. parent_commit .. ' -> ' .. current_commit)
    vim.cmd(cmd)
  end
end

local function git_pickaxe(opts)
  opts = opts or {}
  local is_global = opts.global or false
  local current_file = vim.api.nvim_buf_get_name(0)
  if not is_global and (current_file == '' or current_file == nil) then
    vim.notify('Buffer is invalid, switching to global search', vim.log.levels.WARN)
    is_global = true
  end

  local title_scope = is_global and 'Global' or vim.fn.fnamemodify(current_file, ':t')
  vim.ui.input({ prompt = 'Git Search (-G) in ' .. title_scope .. ': ' }, function(query)
    if not query or query == '' then
      return
    end
    vim.fn.setreg('/', query)
    local old_hl = vim.opt.hlsearch
    vim.opt.hlsearch = true

    local args = {
      'log',
      '-G' .. query,
      '-i',
      '--pretty=format:%C(yellow)%h%Creset %s %C(green)(%cr)%Creset %C(blue)<%an>%Creset',
      '--abbrev-commit',
      '--date=short',
    }
    if not is_global then
      table.insert(args, '--')
      table.insert(args, current_file)
    end

    Snacks.picker {
      title = 'Git Log: "' .. query .. '" (' .. title_scope .. ')',
      finder = 'proc',
      cmd = 'git',
      args = args,
      transform = function(item)
        local clean_text = item.text:gsub('\27%[[0-9;]*m', '')
        local hash = clean_text:match '^%S+'
        if hash then
          item.commit = hash
          if not is_global then
            item.file = current_file
          end
        end
        return item
      end,
      preview = 'git_show',
      confirm = walk_in_codediff,
      format = 'text',
      on_close = function()
        vim.opt.hlsearch = old_hl
        vim.cmd 'noh'
      end,
    }
  end)
end

vim.keymap.set('n', '<leader>Gs', function()
  git_pickaxe { global = false }
end, { desc = 'Git Search (Buffer)' })
vim.keymap.set('n', '<leader>GS', function()
  git_pickaxe { global = true }
end, { desc = 'Git Search (Global)' })
vim.keymap.set({ 'n', 't' }, '<leader>Gl', function()
  Snacks.picker.git_log { confirm = walk_in_codediff }
end, { desc = 'Git Log Repo' })
vim.keymap.set({ 'n', 't' }, '<leader>Gf', function()
  Snacks.picker.git_log_file { confirm = walk_in_codediff }
end, { desc = 'Git Log File' })

local function ai_terminal_sessions()
  local sessions = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local terminal = vim.b[buf].snacks_terminal
    local cmd = terminal and terminal.cmd
    local executable = type(cmd) == 'table' and cmd[1] or cmd
    if (executable == 'codex' or executable == 'opencode' or executable == 'copilot') and vim.b[buf].terminal_job_id then
      table.insert(sessions, {
        buf = buf,
        cmd = executable,
        cwd = terminal.cwd or vim.fn.getcwd(),
        job_id = vim.b[buf].terminal_job_id,
      })
    end
  end
  return sessions
end

local function send_ai_context(session, render_context)
  -- Bracketed paste keeps newlines in interactive CLIs without submitting them.
  local paste = '\027[200~\n' .. render_context(session) .. '\n\n\027[201~'
  local ok, err = pcall(vim.api.nvim_chan_send, session.job_id, paste)
  if not ok then
    vim.notify(('Unable to send context to %s: %s'):format(session.cmd, err), vim.log.levels.ERROR)
    return
  end
  vim.notify(('Added context to %s (%s)'):format(session.cmd, session.cwd))
end

local function select_ai_terminal(render_context)
  local sessions = ai_terminal_sessions()
  if #sessions == 0 then
    vim.notify('No running compatible agent Snacks terminal found', vim.log.levels.WARN)
  elseif #sessions == 1 then
    send_ai_context(sessions[1], render_context)
  else
    Snacks.picker.select(sessions, {
      prompt = 'Add context to AI terminal',
      format_item = function(session)
        return ('%s — %s'):format(session.cmd, session.cwd)
      end,
    }, function(session)
      if session then
        send_ai_context(session, render_context)
      end
    end)
  end
end

local function current_file_path()
  local path = vim.api.nvim_buf_get_name(0)
  return path ~= '' and vim.fs.normalize(vim.fn.fnamemodify(path, ':p')) or '[No Name]'
end

local function relative_path(path, cwd)
  if path == '[No Name]' then
    return path
  end
  return vim.fs.relpath(cwd, path) or path
end

local function location(path, cwd, start_pos, end_pos, kind)
  local name = relative_path(path, cwd)
  local start_row, start_col = start_pos[1], start_pos[2] + 1
  if not end_pos then
    return ('@%s :L%d:C%d'):format(name, start_row, start_col)
  elseif kind == 'V' then
    return start_row == end_pos[1] and ('@%s :L%d'):format(name, start_row) or ('@%s :L%d-L%d'):format(name, start_row, end_pos[1])
  elseif start_row == end_pos[1] and start_col == end_pos[2] + 1 then
    return ('@%s :L%d:C%d'):format(name, start_row, start_col)
  elseif start_row == end_pos[1] then
    return ('@%s :L%d:C%d-C%d'):format(name, start_row, start_col, end_pos[2] + 1)
  end
  return ('@%s :L%d:C%d-L%d:C%d'):format(name, start_row, start_col, end_pos[1], end_pos[2] + 1)
end

local function selected_context()
  local start_pos = vim.fn.getpos "'<"
  local end_pos = vim.fn.getpos "'>"
  return {
    path = current_file_path(),
    start_pos = { start_pos[2], start_pos[3] - 1 },
    end_pos = { end_pos[2], end_pos[3] - 1 },
    kind = vim.fn.visualmode(),
    text = table.concat(vim.fn.getregion(start_pos, end_pos, { type = vim.fn.visualmode() }), '\n'),
  }
end

local function current_line_context()
  local cursor = vim.api.nvim_win_get_cursor(0)
  return { path = current_file_path(), start_pos = { cursor[1], cursor[2] } }
end

vim.keymap.set('n', '<leader>ap', function()
  Snacks.picker.files {
    confirm = function(picker)
      local items = picker:selected { fallback = true }
      picker:close()
      local paths = {}
      for _, item in ipairs(items) do
        if item.file then
          table.insert(paths, vim.fs.normalize(vim.fn.fnamemodify(item.file, ':p')))
        end
      end
      if #paths > 0 then
        select_ai_terminal(function(session)
          local references = {}
          for _, path in ipairs(paths) do
            table.insert(references, '@' .. relative_path(path, session.cwd))
          end
          return table.concat(references, ' ')
        end)
      end
    end,
  }
end, { desc = 'Add Files to AI Context' })

vim.keymap.set('n', '<leader>af', function()
  select_ai_terminal(function(session)
    return '@' .. relative_path(current_file_path(), session.cwd)
  end)
end, { desc = 'Add Current File to AI Context' })

vim.keymap.set('n', '<leader>at', function()
  local context = current_line_context()
  select_ai_terminal(function(session)
    return location(context.path, session.cwd, context.start_pos)
  end)
end, { desc = 'Add Position to AI Context' })

vim.keymap.set('x', '<leader>al', function()
  local context = selected_context()
  select_ai_terminal(function(session)
    return location(context.path, session.cwd, context.start_pos, context.end_pos, context.kind)
  end)
end, { desc = 'Add Selection to AI Context' })

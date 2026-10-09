vim.pack.add { 'https://github.com/akinsho/toggleterm.nvim' }

local Terminal = require('toggleterm.terminal').Terminal
local MiniPick = require 'mini.pick'

local uv = vim.uv or vim.loop

local function map_escape_toggle(term)
  vim.keymap.set('t', '`', function()
    term._esc_timer = term._esc_timer or uv.new_timer()
    if term._esc_timer:is_active() then
      term._esc_timer:stop()
      vim.cmd 'stopinsert'
    else
      local job_id = term.job_id
      term._esc_timer:start(200, 0, function()
        vim.schedule(function()
          vim.api.nvim_chan_send(job_id, '`')
        end)
      end)
    end
  end, { buffer = term.bufnr, expr = true, desc = 'Double backtick to normal mode' })
end

require('toggleterm').setup {
  shell = 'zsh',
  direction = 'vertical',
  size = function(term)
    if term.direction == 'horizontal' then
      return 15
    end
    return math.floor(vim.o.columns * 0.4)
  end,
  start_in_insert = true,
  persist_size = true,
  persist_mode = true,
  shade_terminals = true,
  on_open = map_escape_toggle,
}

local function new_terminal(cmd, name, direction)
  return Terminal:new {
    cmd = cmd,
    display_name = name,
    direction = direction or 'vertical',
    hidden = true,
  }
end

local shell = new_terminal(nil, 'shell')
local agent = new_terminal('opencode', 'opencode')
local copilot = new_terminal('copilot', 'copilot')
local lazygit = new_terminal('lazygit', 'lazygit', 'float')

vim.keymap.set('n', '<leader>tt', function()
  shell:toggle()
end, { desc = 'Terminal' })
vim.keymap.set('n', '<leader>ta', function()
  agent:toggle()
end, { desc = 'Agent' })
vim.keymap.set('n', '<leader>tc', function()
  copilot:toggle()
end, { desc = 'Copilot' })
vim.keymap.set('n', '<leader>og', function()
  lazygit:toggle()
end, { desc = 'Lazygit' })

local agents = { agent = agent, copilot = copilot }

local function ai_terminal_sessions()
  local sessions = {}
  for name, term in pairs(agents) do
    local buf = term.bufnr
    if buf and vim.api.nvim_buf_is_valid(buf) and term.job_id then
      sessions[#sessions + 1] = {
        cmd = name,
        cwd = term.dir or vim.fn.getcwd(),
        job_id = term.job_id,
      }
    end
  end
  return sessions
end

-- Bracketed paste keeps newlines in interactive CLIs without submitting them.
local function send_ai_context(session, render_context)
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
    vim.notify('No running compatible agent terminal found', vim.log.levels.WARN)
  elseif #sessions == 1 then
    send_ai_context(sessions[1], render_context)
  else
    vim.ui.select(sessions, {
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
  local mode_char = vim.fn.mode()
  local in_visual = mode_char:match '^[vV]$' or mode_char == '\022'
  local kind
  if mode_char == 'V' then
    kind = 'V'
  elseif mode_char == 'v' then
    kind = 'v'
  elseif mode_char == '\022' then
    kind = '\022'
  end
  if not in_visual then
    local cursor = vim.api.nvim_win_get_cursor(0)
    return { path = current_file_path(), start_pos = { cursor[1], cursor[2] } }
  end
  vim.cmd('normal! ' .. mode_char)
  local start_pos = vim.fn.getpos "'<"
  local end_pos = vim.fn.getpos "'>"
  vim.fn.feedkeys('gv', 'nx')
  if start_pos[2] == 0 then
    local cursor = vim.api.nvim_win_get_cursor(0)
    return { path = current_file_path(), start_pos = { cursor[1], cursor[2] } }
  end
  local start_row, start_col = start_pos[2], start_pos[3] - 1
  local end_row, end_col = end_pos[2], end_pos[3] - 1
  if start_row > end_row or (start_row == end_row and start_col > end_col) then
    start_row, start_col, end_row, end_col = end_row, end_col, start_row, start_col
    start_pos, end_pos = end_pos, start_pos
  end
  local s_pos = { start_pos[1], start_row, start_col + 1, start_pos[4] }
  local e_pos = { end_pos[1], end_row, end_col + 1, end_pos[4] }
  local ok, region = pcall(vim.fn.getregion, s_pos, e_pos, { type = kind or mode_char or 'v' })
  if not ok then
    region = {}
  end
  return {
    path = current_file_path(),
    start_pos = { start_row, start_col },
    end_pos = { end_row, end_col },
    kind = kind or mode_char or 'v',
    text = table.concat(region, '\n'),
  }
end

local function current_line_context()
  local cursor = vim.api.nvim_win_get_cursor(0)
  return { path = current_file_path(), start_pos = { cursor[1], cursor[2] } }
end

local function list_files_items()
  local cmd
  if vim.fn.executable 'rg' == 1 then
    cmd = { 'rg', '--files', '--hidden', '--glob', '!.git' }
  elseif vim.fn.executable 'fd' == 1 then
    cmd = { 'fd', '--type', 'f', '--hidden', '--exclude', '.git' }
  end
  if cmd then
    local lines = vim.fn.systemlist(cmd)
    if vim.v.shell_error == 0 and #lines > 0 then
      return lines
    end
  end
  local items = {}
  for _, f in ipairs(vim.fn.glob('**/*', false, true)) do
    if vim.fn.isdirectory(f) == 0 then
      items[#items + 1] = f
    end
  end
  return items
end

local function send_paths(items)
  local paths = {}
  for _, item in ipairs(items) do
    local path = type(item) == 'table' and item.path or item
    if path and path ~= '' then
      paths[#paths + 1] = vim.fs.normalize(vim.fn.fnamemodify(path, ':p'))
    end
  end
  if #paths == 0 then
    return
  end
  select_ai_terminal(function(session)
    local references = {}
    for _, path in ipairs(paths) do
      references[#references + 1] = '@' .. relative_path(path, session.cwd)
    end
    return table.concat(references, ' ')
  end)
end

vim.keymap.set('n', '<leader>ap', function()
  MiniPick.start {
    source = {
      name = 'Add Files to AI Context',
      items = list_files_items(),
      choose = function(item)
        send_paths { item }
      end,
      choose_marked = function(items)
        send_paths(items)
      end,
    },
  }
end, { desc = 'Add Files to AI Context' })

vim.keymap.set('n', '<leader>af', function()
  select_ai_terminal(function(session)
    return '@' .. relative_path(current_file_path(), session.cwd)
  end)
end, { desc = 'Add Current File to AI Context' })

vim.keymap.set('n', '<leader>al', function()
  local context = current_line_context()
  select_ai_terminal(function(session)
    return location(context.path, session.cwd, context.start_pos)
  end)
end, { desc = 'Add Position to AI Context' })

vim.keymap.set('x', '<leader>at', function()
  local context = selected_context()
  select_ai_terminal(function(session)
    return location(context.path, session.cwd, context.start_pos, context.end_pos, context.kind)
  end)
end, { desc = 'Add Selection to AI Context' })

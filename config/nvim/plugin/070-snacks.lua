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
  lazygit = {},
  indent = {},
  scope = {},
  toggle = {},
  bigfile = {},
  input = {},
  quickfile = {},
  layout = {},
  terminal = { shell = 'pwsh' },
  statuscolumn = {},
  words = {},
  styles = {
    notification = { wo = { wrap = true } },
    terminal = { width = 0.6, position = 'right' },
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
vim.keymap.set('n', '<leader>sp', function()
  Snacks.picker.lazy()
end, { desc = 'Search for Plugin Spec' })
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
vim.keymap.set('n', '<leader>gN', function()
  Snacks.rename.rename_file()
end, { desc = 'Rename File' })
vim.keymap.set('n', '<leader>og', function()
  Snacks.lazygit()
end, { desc = 'Lazygit' })
vim.keymap.set('n', '<leader>tt', function()
  Snacks.terminal.toggle()
end, { desc = 'Terminal' })
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

vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
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
  end,
})

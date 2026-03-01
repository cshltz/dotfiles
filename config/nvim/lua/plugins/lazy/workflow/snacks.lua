return {
  'folke/snacks.nvim',
  enabled = true,
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
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
        files = {
          hidden = true,
        },
        explorer = {
          auto_close = true,
          layout = {
            preset = 'default',
          },
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
    notifier = {
      timeout = 3000,
      wrap = true,
    },
    dashboard = {
      sections = {
        { section = 'header' },
        { icon = ' ', title = 'Keymaps', section = 'keys', indent = 2, padding = 1 },
        { icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
        { icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
        { section = 'startup' },
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
    terminal = {
      shell = 'pwsh',
    },
    statuscolumn = {},
    words = {},
    styles = {
      notification = {
        wo = { wrap = true }, -- Wrap notifications
      },
      terminal = {
        width = 0.6,
        position = 'right',
      },
      lazygit = {
        width = 0.8,
      },
    },
  },
  keys = {
    -- Top Pickers & Explorer
    {
      '<leader><space>',
      function()
        Snacks.picker.smart()
      end,
      desc = 'Smart Find Files',
    },
    {
      '<leader>:',
      function()
        Snacks.picker.command_history()
      end,
      desc = 'Command History',
    },
    {
      '<leader>oe',
      function()
        Snacks.explorer.reveal()
      end,
      desc = 'Explorer',
    },
    -- Find
    {
      '<leader>fb',
      function()
        Snacks.picker.buffers()
      end,
      desc = 'Buffers',
    },
    {
      '<leader>fc',
      function()
        Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
      end,
      desc = 'Find Config File',
    },
    -- {
    --   '<leader>ff',
    --   function()
    --     Snacks.picker.files()
    --   end,
    --   desc = 'Files',
    -- },
    {
      '<leader>fg',
      function()
        Snacks.picker.git_files()
      end,
      desc = 'Find Git Files',
    },
    {
      '<leader>fp',
      function()
        Snacks.picker.projects()
      end,
      desc = 'Projects',
    },
    {
      '<leader>fr',
      function()
        Snacks.picker.recent()
      end,
      desc = 'Recent',
    },
    {
      '<leader>fC',
      function()
        Snacks.picker.colorschemes()
      end,
      desc = 'Colorschemes',
    },
    -- Grep
    {
      '<leader>sf',
      function()
        Snacks.picker.files()
      end,
      desc = 'Files',
    },
    {
      '<leader>sb',
      function()
        Snacks.picker.lines()
      end,
      desc = 'Buffer Lines',
    },
    {
      '<leader>sB',
      function()
        Snacks.picker.grep_buffers()
      end,
      desc = 'Grep Open Buffers',
    },
    {
      '<leader>sg',
      function()
        Snacks.picker.grep()
      end,
      desc = 'Grep',
    },
    {
      '<leader>sw',
      function()
        Snacks.picker.grep_word()
      end,
      desc = 'Word',
      mode = { 'n', 'x' },
    },
    -- search
    {
      '<leader>s"',
      function()
        Snacks.picker.registers()
      end,
      desc = 'Registers',
    },
    {
      '<leader>s/',
      function()
        Snacks.picker.search_history()
      end,
      desc = 'Search History',
    },
    {
      '<leader>sa',
      function()
        Snacks.picker.autocmds()
      end,
      desc = 'Autocmds',
    },
    {
      '<leader>sb',
      function()
        Snacks.picker.lines()
      end,
      desc = 'Buffer Lines',
    },
    {
      '<leader>sc',
      function()
        Snacks.picker.command_history()
      end,
      desc = 'Command History',
    },
    {
      '<leader>sC',
      function()
        Snacks.picker.commands()
      end,
      desc = 'Commands',
    },
    {
      '<leader>sD',
      function()
        Snacks.picker.diagnostics()
      end,
      desc = 'Global Diagnostics',
    },
    {
      '<leader>sd',
      function()
        Snacks.picker.diagnostics_buffer()
      end,
      desc = 'Buffer Diagnostics',
    },
    {
      '<leader>sh',
      function()
        Snacks.picker.help()
      end,
      desc = 'Help Pages',
    },
    {
      '<leader>sH',
      function()
        Snacks.picker.highlights()
      end,
      desc = 'Highlights',
    },
    {
      '<leader>si',
      function()
        Snacks.picker.icons()
      end,
      desc = 'Icons',
    },
    {
      '<leader>sj',
      function()
        Snacks.picker.jumps()
      end,
      desc = 'Jumps',
    },
    {
      '<leader>sk',
      function()
        Snacks.picker.keymaps()
      end,
      desc = 'Keymaps',
    },
    {
      '<leader>sl',
      function()
        Snacks.picker.loclist()
      end,
      desc = 'Location List',
    },
    {
      '<leader>sm',
      function()
        Snacks.picker.marks()
      end,
      desc = 'Marks',
    },
    {
      '<leader>sM',
      function()
        Snacks.picker.man()
      end,
      desc = 'Man Pages',
    },
    {
      '<leader>sp',
      function()
        Snacks.picker.lazy()
      end,
      desc = 'Search for Plugin Spec',
    },
    {
      '<leader>sq',
      function()
        Snacks.picker.qflist()
      end,
      desc = 'Quickfix List',
    },
    {
      '<leader>sR',
      function()
        Snacks.picker.resume()
      end,
      desc = 'Resume',
    },
    {
      '<leader>su',
      function()
        Snacks.picker.undo()
      end,
      desc = 'Undo History',
    },
    -- LSP
    {
      '<leader>gd',
      function()
        Snacks.picker.lsp_definitions()
      end,
      desc = 'Goto Definition',
    },
    {
      '<leader>gD',
      function()
        Snacks.picker.lsp_declarations()
      end,
      desc = 'Goto Declaration',
    },
    {
      '<leader>gr',
      function()
        Snacks.picker.lsp_references()
      end,
      nowait = true,
      desc = 'References',
    },
    {
      '<leader>gi',
      function()
        Snacks.picker.lsp_implementations()
      end,
      desc = 'Goto Implementation',
    },
    {
      '<leader>gy',
      function()
        Snacks.picker.lsp_type_definitions()
      end,
      desc = 'Goto Type Definition',
    },
    {
      '<leader>gci',
      function()
        Snacks.picker.lsp_incoming_calls()
      end,
      desc = 'Goto Incoming Calls',
    },
    {
      '<leader>gco',
      function()
        Snacks.picker.lsp_outgoing_calls()
      end,
      desc = 'Goto Outgoing Calls',
    },
    {
      '<leader>ss',
      function()
        Snacks.picker.lsp_symbols()
      end,
      desc = 'LSP Symbols',
    },
    {
      '<leader>sS',
      function()
        Snacks.picker.lsp_workspace_symbols()
      end,
      desc = 'LSP Workspace Symbols',
    },
    -- Git
    {
      '<leader>Gb',
      function()
        Snacks.picker.git_branches()
      end,
      desc = 'Git Branches',
    },
    {
      '<leader>GL',
      function()
        Snacks.picker.git_log_line()
      end,
      desc = 'Git Log Line',
    },
    -- {
    --   '<leader>Gl',
    --   function()
    --     Snacks.picker.git_log()
    --   end,
    --   desc = 'Git Log',
    -- },
    -- {
    --   '<leader>Gs',
    --   function()
    --     Snacks.picker.git_status()
    --   end,
    --   desc = 'Git Status',
    -- },
    -- {
    --   '<leader>GS',
    --   function()
    --     Snacks.picker.git_stash()
    --   end,
    --   desc = 'Git Stash',
    -- },
    -- {
    --   '<leader>Gf',
    --   function()
    --     Snacks.picker.git_log_file()
    --   end,
    --   desc = 'Git Log File',
    -- },
    {
      '<leader>Gd',
      function()
        Snacks.picker.git_diff()
      end,
      desc = 'Git Diff (Hunks)',
    },
    {
      '<leader>GB',
      function()
        Snacks.gitbrowse()
      end,
      desc = 'Git Browse',
      mode = { 'n', 'v' },
    },
    -- GH
    {
      '<leader>Ghi',
      function()
        Snacks.picker.gh_issue()
      end,
      desc = 'GitHub Issues (open)',
    },
    {
      '<leader>GhI',
      function()
        Snacks.picker.gh_issue { state = 'all' }
      end,
      desc = 'GitHub Issues (all)',
    },
    {
      '<leader>Ghp',
      function()
        Snacks.picker.gh_pr()
      end,
      desc = 'GitHub Pull Requests (open)',
    },
    {
      '<leader>GhP',
      function()
        Snacks.picker.gh_pr { state = 'all' }
      end,
      desc = 'GitHub Pull Requests (all)',
    },
    -- Other
    -- {
    --   '<leader>z',
    --   function()
    --     Snacks.zen()
    --   end,
    --   desc = 'Toggle Zen Mode',
    -- },
    -- {
    --   '<leader>Z',
    --   function()
    --     Snacks.zen.zoom()
    --   end,
    --   desc = 'Toggle Zoom',
    -- },
    {
      '<leader>.',
      function()
        Snacks.scratch()
      end,
      desc = 'Toggle Scratch Buffer',
    },
    {
      '<leader>S',
      function()
        Snacks.scratch.select()
      end,
      desc = 'Select Scratch Buffer',
    },
    {
      '<leader>bfd',
      function()
        Snacks.bufdelete()
      end,
      desc = 'Delete Buffer',
    },
    {
      '<leader>gN',
      function()
        Snacks.rename.rename_file()
      end,
      desc = 'Rename File',
    },
    {
      '<leader>og',
      function()
        Snacks.lazygit()
      end,
      desc = 'Lazygit',
    },
    -- {
    --   '<leader>ot',
    --   function()
    --     Snacks.terminal.open()
    --   end,
    --   desc = 'Terminal',
    -- },
    {
      '<leader>tt',
      function()
        Snacks.terminal.toggle()
      end,
      desc = 'Terminal',
    },
    {
      ']]',
      function()
        Snacks.words.jump(vim.v.count1)
      end,
      desc = 'Next Reference',
      mode = { 'n', 't' },
    },
    {
      '[[',
      function()
        Snacks.words.jump(-vim.v.count1)
      end,
      desc = 'Prev Reference',
      mode = { 'n', 't' },
    },
    -- Notifications
    {
      '<leader>Nn',
      function()
        Snacks.picker.notifications()
      end,
      desc = 'Notifications',
    },
    {
      '<leader>Nh',
      function()
        Snacks.notifier.show_history()
      end,
      desc = 'Notification History',
    },
    {
      '<leader>Nd',
      function()
        Snacks.notifier.hide()
      end,
      desc = 'Dismiss All Notifications',
    },
  },
  init = function()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        -- _G.dd = function(...)
        --   Snacks.debug.inspect(...)
        -- end
        -- _G.bt = function()
        --   Snacks.debug.backtrace()
        -- end
        --
        -- -- Override print to use snacks for `:=` command
        -- if vim.fn.has("nvim-0.11") == 1 then
        --   vim._print = function(_, ...)
        --     dd(...)
        --   end
        -- else
        --   vim.print = _G.dd
        -- end

        -- Create some toggle mappings
        Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>tus'
        Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>tuw'
        Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map '<leader>tuL'
        Snacks.toggle.diagnostics():map '<leader>tud'
        Snacks.toggle.line_number():map '<leader>tul'
        Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map '<leader>tuc'
        Snacks.toggle.treesitter():map '<leader>tuT'
        -- Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map '<leader>tub'
        Snacks.toggle.inlay_hints():map '<leader>tuh'
        Snacks.toggle.indent():map '<leader>tug'
        Snacks.toggle.dim():map '<leader>tuD'

        local function walk_in_codediff(picker, item)
          picker:close()
          if item.commit then
            local current_commit = item.commit

            vim.fn.setreg('+', current_commit)
            vim.notify('Copied: ' .. current_commit)
            -- get parent / previous commit
            local parent_commit = vim.trim(vim.fn.system('git rev-parse --short ' .. current_commit .. '^'))
            parent_commit = parent_commit:match '[a-f0-9]+'
            -- Check if command failed (e.g., Initial commit has no parent)
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
          -- Force global if current buffer is invalid
          if not is_global and (current_file == '' or current_file == nil) then
            vim.notify('Buffer is not a file, switching to global search', vim.log.levels.WARN)
            is_global = true
          end

          local title_scope = is_global and 'Global' or vim.fn.fnamemodify(current_file, ':t')
          vim.ui.input({ prompt = 'Git Search (-G) in ' .. title_scope .. ': ' }, function(query)
            if not query or query == '' then
              return
            end

            -- set keyword highlight within Snacks.picker
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
                -- remove keyword highlight
                vim.opt.hlsearch = old_hl
                vim.cmd 'noh'
              end,
            }
          end)
        end

        -- Keymaps
        vim.keymap.set('n', '<leader>Gs', function()
          git_pickaxe { global = false }
        end, { desc = 'Git Search (Buffer)' })

        vim.keymap.set('n', '<leader>GS', function()
          git_pickaxe { global = true }
        end, { desc = 'Git Search (Global)' })

        vim.keymap.set({ 'n', 't' }, '<leader>Gl', function()
          Snacks.picker.git_log {
            confirm = walk_in_codediff,
          }
        end, { desc = 'Git Log Repo' })
        vim.keymap.set({ 'n', 't' }, '<leader>Gf', function()
          Snacks.picker.git_log_file {
            confirm = walk_in_codediff,
          }
        end, { desc = 'Git Log File' })
      end,
    })
  end,
}

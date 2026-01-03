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
      sources = {
        files = {
          hidden = true,
        },
        explorer = {
          auto_close = true,
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
    -- terminal = {},
    statuscolumn = {},
    words = {},
    styles = {
      notification = {
        wo = { wrap = true }, -- Wrap notifications
      },
      -- terminal = {
      --   width = 0.6,
      --   position = 'right',
      -- },
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
    -- {
    --   '<leader>,',
    --   function()
    --     Snacks.picker.buffers()
    --   end,
    --   desc = 'Buffers',
    -- },
    -- {
    --   '<leader>/',
    --   function()
    --     Snacks.picker.grep()
    --   end,
    --   desc = 'Grep',
    -- },
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
      '<leader>sd',
      function()
        Snacks.picker.diagnostics()
      end,
      desc = 'Diagnostics',
    },
    {
      '<leader>sD',
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
      desc = 'Incoming',
    },
    {
      '<leader>gco',
      function()
        Snacks.picker.lsp_outgoing_calls()
      end,
      desc = 'Outgoing',
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
      '<leader>Gl',
      function()
        Snacks.picker.git_log()
      end,
      desc = 'Git Log',
    },
    {
      '<leader>GL',
      function()
        Snacks.picker.git_log_line()
      end,
      desc = 'Git Log Line',
    },
    {
      '<leader>Gs',
      function()
        Snacks.picker.git_status()
      end,
      desc = 'Git Status',
    },
    {
      '<leader>GS',
      function()
        Snacks.picker.git_stash()
      end,
      desc = 'Git Stash',
    },
    {
      '<leader>Gd',
      function()
        Snacks.picker.git_diff()
      end,
      desc = 'Git Diff (Hunks)',
    },
    {
      '<leader>Gf',
      function()
        Snacks.picker.git_log_file()
      end,
      desc = 'Git Log File',
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
    -- {
    --   '<leader>tt',
    --   function()
    --     Snacks.terminal.toggle()
    --   end,
    --   desc = 'Terminal',
    -- },
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
      '<leader>nh',
      function()
        Snacks.picker.notifications()
      end,
      desc = 'Notification History',
    },
    {
      '<leader>nh',
      function()
        Snacks.notifier.show_history()
      end,
      desc = 'Notification History',
    },
    {
      '<leader>nd',
      function()
        Snacks.notifier.hide()
      end,
      desc = 'Dismiss All Notifications',
    },
    -- {
    --   '<leader>N',
    --   desc = 'Neovim News',
    --   function()
    --     Snacks.win {
    --       file = vim.api.nvim_get_runtime_file('doc/news.txt', false)[1],
    --       width = 0.6,
    --       height = 0.6,
    --       wo = {
    --         spell = false,
    --         wrap = false,
    --         signcolumn = 'yes',
    --         statuscolumn = ' ',
    --         conceallevel = 3,
    --       },
    --     }
    --   end,
    -- },
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
      end,
    })
  end,
}

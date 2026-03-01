return {
  {
    'mfussenegger/nvim-dap',
    enabled = true,
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'igorlfs/nvim-dap-view',
      'nvim-neotest/nvim-nio',
      'mason-org/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',
      'leoluz/nvim-dap-go',
    },
    config = function()
      local dap = require 'dap'

      require('mason-nvim-dap').setup {
        automatic_setup = true,
        handlers = {},
        ensure_installed = {},
      }

      -- Basic debugging keymaps, feel free to change to your liking!
      vim.keymap.set('n', '<leader>ob', dap.continue, { desc = 'Debug' })

      vim.keymap.set('n', '<leader>bb', dap.toggle_breakpoint, { desc = 'Breakpoint' })
      vim.keymap.set('n', '<leader>bc', function()
        dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end, { desc = 'Set conditional' })

      local dapview = require 'dap-view'
      dapview.setup {
        winbar = {
          show = true,
          sections = { 'watches', 'scopes', 'exceptions', 'breakpoints', 'threads', 'repl' },
          default_section = 'watches',
          show_keymap_hints = true,
          base_sections = {
            breakpoints = { label = 'Breakpoints', keymap = 'B' },
            scopes = { label = 'Scopes', keymap = 'S' },
            exceptions = { label = 'Exceptions', keymap = 'E' },
            watches = { label = 'Watches', keymap = 'W' },
            threads = { label = 'Threads', keymap = 'T' },
            repl = { label = 'REPL', keymap = 'R' },
            sessions = { label = 'Sessions', keymap = 'K' },
            console = { label = 'Console', keymap = 'C' },
          },
          custom_sections = {},
          controls = {
            enabled = false,
            position = 'right',
            buttons = {
              'play',
              'step_into',
              'step_over',
              'step_out',
              'step_back',
              'run_last',
              'terminate',
              'disconnect',
            },
            custom_buttons = {},
          },
        },
        windows = {
          size = 0.25,
          position = 'below',
          terminal = {
            size = 0.5,
            position = 'left',
            hide = {},
          },
        },
        icons = {
          collapsed = '󰅂 ',
          disabled = '',
          disconnect = '',
          enabled = '',
          expanded = '󰅀 ',
          filter = '󰈲',
          negate = ' ',
          pause = '',
          play = '',
          run_last = '',
          step_back = '',
          step_into = '',
          step_out = '',
          step_over = '',
          terminate = '',
        },
        help = {
          border = nil,
        },
        render = {
          sort_variables = nil,
          threads = {
            format = function(name, lnum, path)
              return {
                { part = name, separator = ' ' },
                { part = path, hl = 'FileName', separator = ':' },
                { part = lnum, hl = 'LineNumber' },
              }
            end,
            align = false,
          },
          breakpoints = {
            format = function(line, lnum, path)
              return {
                { part = path, hl = 'FileName' },
                { part = lnum, hl = 'LineNumber' },
                { part = line, hl = true },
              }
            end,
            align = false,
          },
        },
        -- Controls how to jump when selecting a breakpoint or navigating the stack
        -- Comma separated list, like the built-in 'switchbuf'. See :help 'switchbuf'
        -- Only a subset of the options is available: newtab, useopen, usetab and uselast
        -- Can also be a function that takes the current winnr and the destination bufnr
        -- If a function, should return the winnr of the destination window
        switchbuf = 'usetab,uselast',
        -- Auto open when a session is started and auto close when all sessions finish
        -- Alternatively, can be a string:
        -- - "keep_terminal": as above, but keeps the terminal when the session finishes
        -- - "open_term": open the terminal when starting a new session, nothing else
        auto_toggle = true,
        -- Reopen dapview when switching to a different tab
        -- Can also be a function to dynamically choose when to follow, by returning a boolean
        -- If a function, receives the name of the adapter for the current session as an argument
        follow_tab = false,
      }

      vim.keymap.set('n', '<leader>tb', function()
        dapview.toggle()
      end, { desc = 'Debug' })

      -- Install golang specific config
      require('dap-go').setup()
    end,
  },
}

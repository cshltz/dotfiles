vim.pack.add({ 'https://github.com/mfussenegger/nvim-dap' })
vim.pack.add({ 'https://github.com/igorlfs/nvim-dap-view' })
vim.pack.add({ 'https://github.com/nvim-neotest/nvim-nio' })
vim.pack.add({ 'https://github.com/jay-babu/mason-nvim-dap.nvim' })
vim.pack.add({ 'https://github.com/leoluz/nvim-dap-go' })

vim.api.nvim_create_autocmd('VimEnter', {
  once = true,
  callback = function()
    vim.defer_fn(function()
      require('mason-nvim-dap').setup {
        automatic_setup = true,
        handlers = {},
        ensure_installed = {},
      }

      local dap = require 'dap'

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
              'play', 'step_into', 'step_over', 'step_out', 'step_back', 'run_last', 'terminate', 'disconnect',
            },
            custom_buttons = {},
          },
        },
        windows = {
          size = 0.25,
          position = 'below',
          terminal = { size = 0.5, position = 'left', hide = {} },
        },
        icons = {
          collapsed = '󰅂 ', disabled = '', disconnect = '', enabled = '', expanded = '󰅀 ',
          filter = '󰈲', negate = ' ', pause = '', play = '', run_last = '',
          step_back = '', step_into = '', step_out = '', step_over = '', terminate = '',
        },
        help = { border = nil },
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
        switchbuf = 'usetab,uselast',
        auto_toggle = true,
        follow_tab = false,
      }

      vim.keymap.set('n', '<leader>tb', function()
        dapview.toggle()
      end, { desc = 'Debug' })

      require('dap-go').setup()
    end, 1000)
  end,
})

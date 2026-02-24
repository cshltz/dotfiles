return {
  {
    'mfussenegger/nvim-dap',
    enabled = true,
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      -- 'rcarriga/nvim-dap-ui',
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
      -- vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'Step Into' })
      -- vim.keymap.set('n', '<leader>do', dap.step_over, { desc = 'Step Over' })
      -- vim.keymap.set('n', '<leader>du', dap.step_out, { desc = 'Step Out' })

      vim.keymap.set('n', '<leader>bb', dap.toggle_breakpoint, { desc = 'Breakpoint' })
      vim.keymap.set('n', '<leader>bc', function()
        dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end, { desc = 'Set conditional' })

      -- local dapui = require 'dapui'
      -- vim.keymap.set('n', '<leader>dt', dapui.toggle, { desc = 'Toggle' })
      -- dapui.setup {
      --   icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      --   controls = {
      --     icons = {
      --       pause = '',
      --       play = '',
      --       step_into = '',
      --       step_over = '',
      --       step_out = '',
      --       step_back = '',
      --       run_last = '▶▶',
      --       terminate = '',
      --       disconnect = '',
      --     },
      --   },
      -- }
      -- dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      -- dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      -- dap.listeners.before.event_exited['dapui_config'] = dapui.close

      local dapview = require 'dap-view'
      dapview.setup {
        winbar = {
          controls = {
            enabled = false,
          },
        },
      }
      vim.keymap.set('n', '<leader>tb', function()
        dapview.toggle()
      end, { desc = 'Debug' })

      -- Install golang specific config
      require('dap-go').setup()
    end,
  },
}

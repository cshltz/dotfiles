return {
    {
        'mfussenegger/nvim-dap',
        enabled = true,
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            'rcarriga/nvim-dap-ui',
            'nvim-neotest/nvim-nio',
            'mason-org/mason.nvim',
            'jay-babu/mason-nvim-dap.nvim',
            'leoluz/nvim-dap-go',
        },
        config = function()
            local dap = require 'dap'
            local dapui = require 'dapui'

            require('mason-nvim-dap').setup {
                -- Makes a best effort to setup the various debuggers with
                -- reasonable debug configurations
                automatic_setup = true,

                -- You can provide additional configuration to the handlers,
                -- see mason-nvim-dap README for more information
                handlers = {},

                -- You'll need to check that you have the required things installed
                -- online, please don't ask me how to install them :)
                ensure_installed = {},
            }

            -- Basic debugging keymaps, feel free to change to your liking!
            vim.keymap.set('n', '<leader>dt', dapui.toggle, { desc = 'Toggle' })
            vim.keymap.set('n', '<leader>dc', dap.continue, { desc = 'Continue' })
            vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'Step Into' })
            vim.keymap.set('n', '<leader>do', dap.step_over, { desc = 'Step Over' })
            vim.keymap.set('n', '<leader>du', dap.step_out, { desc = 'Step Out' })

            vim.keymap.set('n', '<leader>bt', dap.toggle_breakpoint, { desc = 'Toggle' })
            vim.keymap.set('n', '<leader>bs', function()
                dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
            end, { desc = 'Set' })

            -- Dap UI setup
            -- For more information, see |:help nvim-dap-ui|
            dapui.setup {
                -- Set icons to characters that are more likely to work in every terminal.
                --    Feel free to remove or use ones that you like more! :)
                --    Don't feel like these are good choices.
                icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
                controls = {
                    icons = {
                        pause = '',
                        play = '',
                        step_into = '',
                        step_over = '',
                        step_out = '',
                        step_back = '',
                        run_last = '▶▶',
                        terminate = '',
                        disconnect = '',
                    },
                },
            }

            -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.

            dap.listeners.after.event_initialized['dapui_config'] = dapui.open
            dap.listeners.before.event_terminated['dapui_config'] = dapui.close
            dap.listeners.before.event_exited['dapui_config'] = dapui.close

            -- Install golang specific config
            require('dap-go').setup()
        end,
    },
}

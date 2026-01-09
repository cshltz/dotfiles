return {
  {
    'GustavEikaas/easy-dotnet.nvim',
    enabled = true,
    dependencies = { 'nvim-lua/plenary.nvim', 'folke/snacks.nvim' },
    lazy = true,
    cmd = { 'Dotnet', 'DotnetTest', 'DotnetBuild' },
    ft = { 'cs', 'csproj' },
    config = function()
      require('easy-dotnet').setup {
        lsp = {
          enabled = false,
        },
      }

      local dotnet = require 'easy-dotnet'
      vim.keymap.set('n', '<leader>dnb', function()
        dotnet.build_solution()
      end, { nowait = true, desc = 'Build Solution' })
      vim.keymap.set('n', '<leader>dnr', function()
        dotnet.restore()
      end, { nowait = true, desc = 'Restore' })
      vim.keymap.set('n', '<leader>dnd', function()
        dotnet.debug()
      end, { nowait = true, desc = 'Start Debugging' })
      vim.keymap.set('n', '<leader>dnt', function()
        dotnet.testrunner()
      end, { nowait = true, desc = 'Test Runner' })
      vim.keymap.set('n', '<leader>dns', function()
        dotnet.solution_select()
      end, { nowait = true, desc = 'Select Solution' })
    end,
  },
}

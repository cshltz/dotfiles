return {
  {
    'GustavEikaas/easy-dotnet.nvim',
    enabled = true,
    dependencies = { 'nvim-lua/plenary.nvim', 'folke/snacks.nvim' },
    lazy = false,
    cmd = { 'Dotnet', 'DotnetTest', 'DotnetBuild' },
    config = function()
      require('easy-dotnet').setup {}

      local dotnet = require 'easy-dotnet'
      vim.keymap.set('n', '<leader>Db', function()
        dotnet.build_solution()
      end, { nowait = true, desc = 'Build Solution' })
      vim.keymap.set('n', '<leader>Dr', function()
        dotnet.run()
      end, { nowait = true, desc = 'Run' })
      vim.keymap.set('n', '<leader>Do', function()
        dotnet.restore()
      end, { nowait = true, desc = 'Restore' })
      vim.keymap.set('n', '<leader>Dd', function()
        dotnet.debug()
      end, { nowait = true, desc = 'Start Debugging' })
      vim.keymap.set('n', '<leader>Dt', function()
        dotnet.testrunner()
      end, { nowait = true, desc = 'Test Runner' })
      vim.keymap.set('n', '<leader>Ds', function()
        dotnet.solution_select()
      end, { nowait = true, desc = 'Select Solution' })
    end,
  },
}

return {
  {
    'GustavEikaas/easy-dotnet.nvim',
    enabled = true,
    lazy = false,
    dependencies = { 'nvim-lua/plenary.nvim', 'folke/snacks.nvim' },
    config = function()
      require('easy-dotnet').setup {
        lsp = {
          enabled = true,
          preload_roslyn = true,
          roslynator_enabled = true,
          easy_dotnet_analyzer_enabled = true,
          auto_refresh_codelens = true,
          analyzer_assemblies = {},
          config = {
            settings = {
              -- ['csharp|background_analysis'] = {
              --   dotnet_compiler_diagnostics_scope = 'fullSolution',
              -- },
              ['csharp|inlay_hints'] = {
                csharp_enable_inlay_hints_for_implicit_object_creation = true,
              },
              ['csharp|code_lens'] = {
                dotnet_enable_references_code_lens = true,
              },
            },
          },
        },
      }

      local dotnet = require 'easy-dotnet'
      vim.keymap.set('n', '<leader>nb', function()
        dotnet.build_solution()
      end, { nowait = true, desc = 'Build Solution' })
      vim.keymap.set('n', '<leader>nr', function()
        dotnet.run()
      end, { nowait = true, desc = 'Run' })
      vim.keymap.set('n', '<leader>no', function()
        dotnet.restore()
      end, { nowait = true, desc = 'Restore' })
      vim.keymap.set('n', '<leader>nd', function()
        dotnet.debug()
      end, { nowait = true, desc = 'Start Debugging' })
      vim.keymap.set('n', '<leader>nt', function()
        dotnet.testrunner()
      end, { nowait = true, desc = 'Test Runner' })
      vim.keymap.set('n', '<leader>ns', function()
        dotnet.solution_select()
      end, { nowait = true, desc = 'Select Solution' })
      vim.keymap.set('n', '<leader>nlr', function()
        dotnet.lsp_restart()
      end, { nowait = true, desc = 'Restart' })
      vim.keymap.set('n', '<leader>np', function()
        dotnet.project_view()
      end, { nowait = true, desc = 'Projects' })
    end,
  },
}

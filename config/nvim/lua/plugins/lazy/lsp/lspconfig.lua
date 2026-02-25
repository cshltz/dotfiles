return {
  {
    'neovim/nvim-lspconfig',
    enabled = true,
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'saghen/blink.cmp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = desc })
          end

          map('<leader>gn', vim.lsp.buf.rename, 'Rename')
          map('<leader>ga', vim.lsp.buf.code_action, 'Code Action', { 'n', 'x' })

          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end
        end,
      })

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      local servers = {
        clangd = {},
        gopls = {},
        pyright = {},
        rust_analyzer = {},
        bashls = {},
        lua_ls = {
          -- cmd = { ... },
          -- filetypes = { ... },
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
        -- roslyn = {
        --   on_attach = function()
        --     vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
        --       group = vim.api.nvim_create_augroup('DotnetCodeLensRefresh', { clear = true }),
        --       callback = function(args)
        --         vim.lsp.codelens.refresh { bufnr = args.buf }
        --       end,
        --       desc = 'Refresh .NET code lense on InsertLeave, BufEnter and CursorHold',
        --     })
        --   end,
        --   settings = {
        --     ['csharp|completion'] = {
        --       dotnet_provide_regex_completions = true,
        --       dotnet_show_completion_items_from_unimported_namespaces = true,
        --       dotnet_show_name_completion_suggestions = true,
        --     },
        --     ['csharp|code_lens'] = {
        --       dotnet_enable_references_code_lens = true,
        --       dotnet_enable_tests_code_lens = true,
        --     },
        --     ['csharp|inlay_hints'] = {
        --       csharp_enable_inlay_hints_for_implicit_object_creation = true,
        --       csharp_enable_inlay_hints_for_implicit_variable_types = true,
        --       csharp_enable_inlay_hints_for_lambda_parameter_types = true,
        --       csharp_enable_inlay_hints_for_types = true,
        --       dotnet_enable_inlay_hints_for_indexer_parameters = true,
        --       dotnet_enable_inlay_hints_for_literal_parameters = true,
        --       dotnet_enable_inlay_hints_for_object_creation_parameters = true,
        --       dotnet_enable_inlay_hints_for_other_parameters = true,
        --       dotnet_enable_inlay_hints_for_parameters = true,
        --       dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = false,
        --       dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = false,
        --       dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = false,
        --     },
        --   },
        -- },
        -- copilot = {},
      }

      local debuggers = {
        'delve',
        'codelldb',
        'netcoredbg',
      }

      local linters = {}

      local formatters = {
        'stylua',
        'prettier',
        -- 'csharpier',
        'yamlfix',
      }

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, debuggers)
      vim.list_extend(ensure_installed, linters)
      vim.list_extend(ensure_installed, formatters)

      vim.keymap.set('n', '<leader>um', '<cmd>MasonToolsInstall<cr>', { desc = 'Mason Tools' })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        ensure_installed = {}, -- explicitly set to an empty table (populates installs via mason-tool-installer)
        automatic_installation = false,
        handlers = {
          function(server_name)
            vim.lsp.enable(server_name)
          end,
        },
      }
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et

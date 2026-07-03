vim.pack.add { 'https://github.com/mason-org/mason.nvim' }
vim.pack.add { 'https://github.com/mason-org/mason-lspconfig.nvim' }
vim.pack.add { 'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim' }
vim.pack.add { 'https://github.com/j-hui/fidget.nvim' }

require('mason').setup {}
require('fidget').setup {}

local servers = {
  bashls = {},
  clangd = {},
  gopls = {},
  lemminx = {},
  lua_ls = {
    settings = {
      Lua = {
        completion = { callSnippet = 'Replace' },
        diagnostics = { disable = { 'missing-fields' } },
      },
    },
  },
  powershell_es = {},
  pylsp = {},
  rust_analyzer = {},
}

local debuggers = { 'delve', 'codelldb' }
local linters = {}
local formatters = { 'stylua', 'prettier', 'yamlfix', 'ruff' }

local ensure_installed = vim.tbl_keys(servers)
vim.list_extend(ensure_installed, debuggers)
vim.list_extend(ensure_installed, linters)
vim.list_extend(ensure_installed, formatters)

vim.keymap.set('n', '<leader>um', '<cmd>MasonToolsInstall<cr>', { desc = 'Mason Tools' })
require('mason-tool-installer').setup { ensure_installed = ensure_installed }

require('mason-lspconfig').setup {
  ensure_installed = {},
  automatic_installation = false,
  handlers = {
    function(server_name)
      vim.lsp.enable(server_name)
    end,
  },
}

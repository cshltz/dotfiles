vim.pack.add { 'https://github.com/stevearc/conform.nvim' }

require('conform').setup {
  async = true,
  notify_on_error = false,
  format_on_save = function(bufnr)
    local disable_filetypes = { c = true, cpp = true, props = true, xml = true, ps1 = true }
    if disable_filetypes[vim.bo[bufnr].filetype] then
      return nil
    else
      return { timeout_ms = 500, lsp_format = 'fallback' }
    end
  end,
  formatters_by_ft = {
    cs = { lsp_format = 'first' },
    csproj = { lsp_format = 'first' },
    lua = { 'stylua' },
    yaml = { 'yamlfix' },
    yml = { 'yamlfix' },
    rust = { 'rustfmt', lsp_format = 'fallback' },
    python = { 'isort', 'black' },
  },
  formatters = {
    cs_formatter = {
      command = 'csharpier',
      args = { 'format', '--write-stdout' },
      to_stdin = true,
    },
  },
}

vim.keymap.set('n', '<leader>=', function()
  require('conform').format { async = true, lsp_format = 'fallback' }
end, { desc = 'Format' })

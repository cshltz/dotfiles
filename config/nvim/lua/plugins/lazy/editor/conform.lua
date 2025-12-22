return {
  {
    'stevearc/conform.nvim',
    enabled = true,
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>=',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = 'Format',
      },
    },
    opts = {
      async = true,
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters_by_ft = {
        cs = { 'cs_formatter' },
        csproj = { 'cs_formatter' },
        lua = { 'stylua' },
        yaml = { 'yamlfix' },
        yml = { 'yamlfix' },
        rust = { 'rustfmt', lsp_format = 'fallback' },
        python = { 'isort', 'black' },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
      },
      formatters = {
        cs_formatter = {
          command = 'csharpier',
          args = {
            'format',
            '--write-stdout',
          },
          to_stdin = true,
        },
      },
    },
  },
}

-- vim: ts=2 sts=2 sw=2 et

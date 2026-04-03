vim.pack.add { 'https://github.com/folke/lazydev.nvim' }

require('lazydev').setup {
  library = {
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  },
}

vim.api.nvim_create_autocmd('BufReadPre', {
  once = true,
  callback = function()
    vim.pack.add {
      {
        src = 'https://github.com/saghen/blink.cmp',
        version = vim.version.range '*',
      },
    }

    require('blink.cmp').setup {
      keymap = {
        preset = 'super-tab',
        ['<C-y>'] = { 'select_and_accept' },
        ['<C-j>'] = { 'select_next', 'fallback' },
        ['<C-k>'] = { 'select_prev', 'fallback' },
      },
      appearance = {
        nerd_font_variant = 'mono',
      },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
        accept = { auto_brackets = { enabled = true } },
      },
      sources = {
        default = { 'lsp', 'easy-dotnet', 'path', 'snippets', 'buffer', 'lazydev' },
        providers = {
          ['easy-dotnet'] = {
            name = 'easy-dotnet',
            enabled = true,
            module = 'easy-dotnet.completion.blink',
            score_offset = 10000,
            async = true,
          },
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },
      snippets = { preset = 'luasnip' },
      fuzzy = { implementation = 'prefer_rust_with_warning' },
      signature = { enabled = true },
    }
  end,
})


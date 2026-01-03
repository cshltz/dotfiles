require('lazy').setup({
  spec = {
    { import = 'plugins.lazy.ai' },
    { import = 'plugins.lazy.editor' },
    { import = 'plugins.lazy.git' },
    { import = 'plugins.lazy.lsp' },
    { import = 'plugins.lazy.theme' },
    { import = 'plugins.lazy.ui' },
    { import = 'plugins.lazy.workflow' },
  },
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- vim: ts=2 sts=2 sw=2 et

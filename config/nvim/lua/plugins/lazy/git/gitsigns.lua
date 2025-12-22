return {
  {
    'lewis6991/gitsigns.nvim',
    enabled = true,
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end
        -- Toggles
        map('n', '<leader>tGb', gitsigns.toggle_current_line_blame, { desc = 'Blame' })
        map('n', '<leader>tGd', gitsigns.preview_hunk_inline, { desc = 'Show Deleted' })
      end,
    },
  },
}

-- vim: ts=2 sts=2 sw=2 et

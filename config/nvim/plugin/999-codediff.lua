if false then
  vim.pack.add { 'https://github.com/esmuellert/codediff.nvim' }
  vim.pack.add { 'https://github.com/MunifTanjim/nui.nvim' }

  require('codediff').setup {
    diff = { conflict_ours_position = 'left' },
    keymaps = {
      view = {
        next_file = 'nf',
        prev_file = 'pf',
        next_hunk = 'nc',
        prev_hunk = 'pc',
      },
      conflict = {
        next_conflict = 'nx',
        prev_conflict = 'px',
      },
    },
  }

  vim.keymap.set('n', '<leader>td', '<cmd>CodeDiff<cr>', { desc = 'Difftool' })
end

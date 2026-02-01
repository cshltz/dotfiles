return {
  {
    'esmuellert/codediff.nvim',
    enabled = true,
    dependencies = { 'MunifTanjim/nui.nvim' },
    cmd = 'CodeDiff',
    keys = {
      {
        '<leader>td',
        '<cmd>CodeDiff<cr>',
        desc = 'Difftool',
      },
    },
    config = function()
      require('codediff').setup {
        diff = {
          conflict_ours_position = 'left',
        },
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
    end,
  },
}

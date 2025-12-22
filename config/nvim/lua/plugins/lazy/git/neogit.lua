return {
  {
    'NeogitOrg/neogit',
    enabled = false,
    lazy = true,
    cmd = 'Neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
      'folke/snacks.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      kind = 'tab',
      integrations = {
        diffview = true,
      },
    },
    keys = {
      { '<leader>og', '<cmd>Neogit<cr>', desc = 'Neogit' },
    },
  },
}

return {
  {
    'epwalsh/obsidian.nvim',
    enabled = false,
    version = '*',
    lazy = true,
    ft = 'markdown',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'saghen/blink.cmp',
    },
    opts = {
      workspaces = {
        {
          name = 'personal',
          path = '~/vaults/notes',
        },
        {
          name = 'work',
          path = '~/vaults/work',
        },
      },
    },
  },
}

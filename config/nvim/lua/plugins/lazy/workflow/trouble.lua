return {
  {
    'folke/trouble.nvim',
    enabled = true,
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = 'Trouble',
    keys = {
      {
        '<leader>trx',
        '<cmd>Trouble diagnostics toggle<cr>',
        desc = 'Diagnostics',
      },
      {
        '<leader>trX',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = 'Buffer Diagnostics',
      },
      {
        '<leader>trs',
        '<cmd>Trouble symbols toggle focus=false<cr>',
        desc = 'Symbols',
      },
      {
        '<leader>trl',
        '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
        desc = 'LSP Definitions',
      },
      {
        '<leader>trL',
        '<cmd>Trouble loclist toggle<cr>',
        desc = 'Location List',
      },
      {
        '<leader>trQ',
        '<cmd>Trouble qflist toggle<cr>',
        desc = 'Quickfix List',
      },
    },
  },
}

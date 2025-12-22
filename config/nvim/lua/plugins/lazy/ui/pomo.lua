return {
  {
    'epwalsh/pomo.nvim',
    enabled = true,
    version = '*',
    lazy = true,
    cmd = { 'TimerStart', 'TimerRepeat', 'TimerSession' },
    dependencies = {
      'folke/snacks.nvim',
    },
    keys = {
      { '<leader>tp', '<cmd>TimerSession pmo<cr>', desc = 'Pomo' },
    },
    opts = {
      update_interval = 10000,
      notifiers = {
        {
          name = 'Default',
          opts = {
            sticky = false,
            title_icon = '󱎫',
            text_icon = '󰄉',
          },
        },
      },

      sessions = {
        pmo = {
          { name = 'Work', duration = '25m' },
          { name = 'Short Break', duration = '5m' },
          { name = 'Work', duration = '25m' },
          { name = 'Short Break', duration = '5m' },
          { name = 'Work', duration = '25m' },
          { name = 'Short Break', duration = '5m' },
          { name = 'Work', duration = '25m' },
          { name = 'Long Break', duration = '15m' },
        },
      },
    },
  },
}

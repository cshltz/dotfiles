return {
  {
    'cbochs/grapple.nvim',
    opts = {
      scope = 'git_branch',
    },
    event = { 'BufReadPost', 'BufNewFile' },
    cmd = 'Grapple',
    keys = {
      { '<leader>tm', '<cmd>Grapple toggle<cr>', desc = 'Mark' },
      { '<leader>om', '<cmd>Grapple toggle_tags<cr>', desc = 'Marks' },

      { '<leader>ma', '<cmd>Grapple select index=1<cr>', desc = 'First Mark' },
      { '<leader>ms', '<cmd>Grapple select index=2<cr>', desc = 'Second Mark' },
      { '<leader>md', '<cmd>Grapple select index=3<cr>', desc = 'Third Mark' },
      { '<leader>mf', '<cmd>Grapple select index=4<cr>', desc = 'Fourth Mark' },
      { '<leader>mg', '<cmd>Grapple select index=5<cr>', desc = 'Fifth Mark' },

      {
        '<leader>mma',
        function()
          local grapple = require 'grapple'
          if grapple.exists { index = 1 } then
            grapple.untag { index = 1 }
          end
          grapple.tag { index = 1 }
        end,
        desc = 'Mark First',
      },
      {
        '<leader>mms',
        function()
          local grapple = require 'grapple'
          if grapple.exists { index = 2 } then
            grapple.untag { index = 2 }
          end
          grapple.tag { index = 2 }
        end,
        desc = 'Mark Second',
      },
      {
        '<leader>mmd',
        function()
          local grapple = require 'grapple'
          if grapple.exists { index = 3 } then
            grapple.untag { index = 3 }
          end
          grapple.tag { index = 3 }
        end,
        desc = 'Mark Third',
      },
      {
        '<leader>mmf',
        function()
          local grapple = require 'grapple'
          if grapple.exists { index = 4 } then
            grapple.untag { index = 4 }
          end
          grapple.tag { index = 4 }
        end,
        desc = 'Mark Fourth',
      },
      {
        '<leader>mmg',
        function()
          local grapple = require 'grapple'
          if grapple.exists { index = 5 } then
            grapple.untag { index = 5 }
          end
          grapple.tag { index = 5 }
        end,
        desc = 'Mark Fifth',
      },
    },
  },
}

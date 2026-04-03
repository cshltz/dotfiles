vim.pack.add { 'https://github.com/cbochs/grapple.nvim' }

require('grapple').setup {
  scope = 'git_branch',
}

vim.keymap.set('n', '<leader>tm', '<cmd>Grapple toggle<cr>', { desc = 'Mark' })
vim.keymap.set('n', '<leader>om', '<cmd>Grapple toggle_tags<cr>', { desc = 'Marks' })

vim.keymap.set('n', '<leader>ma', '<cmd>Grapple select index=1<cr>', { desc = 'First Mark' })
vim.keymap.set('n', '<leader>ms', '<cmd>Grapple select index=2<cr>', { desc = 'Second Mark' })
vim.keymap.set('n', '<leader>md', '<cmd>Grapple select index=3<cr>', { desc = 'Third Mark' })
vim.keymap.set('n', '<leader>mf', '<cmd>Grapple select index=4<cr>', { desc = 'Fourth Mark' })
vim.keymap.set('n', '<leader>mg', '<cmd>Grapple select index=5<cr>', { desc = 'Fifth Mark' })

vim.keymap.set('n', '<leader>mma', function()
  local grapple = require 'grapple'
  if grapple.exists { index = 1 } then
    grapple.untag { index = 1 }
  end
  grapple.tag { index = 1 }
end, { desc = 'Mark First' })
vim.keymap.set('n', '<leader>mms', function()
  local grapple = require 'grapple'
  if grapple.exists { index = 2 } then
    grapple.untag { index = 2 }
  end
  grapple.tag { index = 2 }
end, { desc = 'Mark Second' })
vim.keymap.set('n', '<leader>mmd', function()
  local grapple = require 'grapple'
  if grapple.exists { index = 3 } then
    grapple.untag { index = 3 }
  end
  grapple.tag { index = 3 }
end, { desc = 'Mark Third' })
vim.keymap.set('n', '<leader>mmf', function()
  local grapple = require 'grapple'
  if grapple.exists { index = 4 } then
    grapple.untag { index = 4 }
  end
  grapple.tag { index = 4 }
end, { desc = 'Mark Fourth' })
vim.keymap.set('n', '<leader>mmg', function()
  local grapple = require 'grapple'
  if grapple.exists { index = 5 } then
    grapple.untag { index = 5 }
  end
  grapple.tag { index = 5 }
end, { desc = 'Mark Fifth' })

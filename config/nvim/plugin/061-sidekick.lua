vim.pack.add { 'https://github.com/folke/sidekick.nvim' }

vim.lsp.inline_completion.enable(false)

require('sidekick').setup {
  cli = {
    win = {
      layout = 'right',
      split = {
        width = math.floor(vim.o.columns * 0.6),
      },
      keys = { prompt = false },
    },
    tools = {
      codex = { cmd = { 'codex' } },
    },
  },
  nes = { enabled = false },
}

vim.keymap.set('n', '<leader>tc', function()
  vim.lsp.inline_completion.enable(not vim.lsp.inline_completion.is_enabled())
  require('sidekick.nes').enable(vim.lsp.inline_completion.is_enabled())
  vim.b.completion = not vim.lsp.inline_completion.is_enabled()
  vim.notify(string.format('Inline Completion set to %s', tostring(vim.lsp.inline_completion.is_enabled())))
end, { expr = true, desc = 'Completions' })

vim.keymap.set({ 'i', 'n' }, '<tab>', function()
  if not require('sidekick').nes_jump_or_apply() then
    if vim.lsp.inline_completion.is_enabled() then
      return vim.lsp.inline_completion.get()
    else
      return '<Tab>'
    end
  end
end, { expr = true, desc = 'Goto/Apply Next Edit Suggestion' })

vim.keymap.set({ 'n', 't', 'i', 'x' }, '<c-.>', function()
  require('sidekick.cli').toggle()
end, { desc = 'Sidekick Toggle' })

vim.keymap.set('n', '<leader>ta', function()
  require('sidekick.cli').toggle { filter = { installed = true } }
end, { desc = 'Sidekick CLI' })
vim.keymap.set('n', '<leader>as', function()
  require('sidekick.cli').select { filter = { installed = true } }
end, { desc = 'Select CLI' })
vim.keymap.set('n', '<leader>ad', function()
  require('sidekick.cli').close()
end, { desc = 'Detach a CLI Session' })
vim.keymap.set({ 'n', 'x' }, '<leader>at', function()
  require('sidekick.cli').send { msg = '{this}' }
end, { desc = 'Send This' })
vim.keymap.set('n', '<leader>af', function()
  require('sidekick.cli').send { msg = '{file}' }
end, { desc = 'Send File' })
vim.keymap.set('x', '<leader>av', function()
  require('sidekick.cli').send { msg = '{selection}' }
end, { desc = 'Send Visual Selection' })
vim.keymap.set({ 'n', 'x' }, '<leader>ap', function()
  require('sidekick.cli').prompt()
end, { desc = 'Sidekick Select Prompt' })

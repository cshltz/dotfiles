vim.pack.add { 'https://github.com/nvim-mini/mini.ai' }
require('mini.ai').setup {
  n_lines = 500,
}

vim.pack.add { 'https://github.com/nvim-mini/mini.surround' }
require('mini.surround').setup {}

vim.pack.add { 'https://github.com/nvim-mini/mini.icons' }
require('mini.icons').setup {
  file = {
    ['.keep'] = { glyph = '󰊢', hl = 'MiniIconsGrey' },
    ['devcontainer.json'] = { glyph = '', hl = 'MiniIconsAzure' },
  },
  filetype = {
    dotenv = { glyph = '', hl = 'MiniIconsYellow' },
  },
}
package.preload['nvim-web-devicons'] = function()
  require('mini.icons').mock_nvim_web_devicons()
  return package.loaded['nvim-web-devicons']
end

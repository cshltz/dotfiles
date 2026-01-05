return {
  {
    'seblyng/roslyn.nvim',
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    ft = { 'cs', 'razor' },
    opts = {
      filewatching = 'roslyn',
      -- silent = true,
      broad_search = true,
    },
  },
}

return {
  {
    'seblyng/roslyn.nvim',
    enabled = false,
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

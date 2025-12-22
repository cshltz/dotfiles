return {
  {
    'GustavEikaas/easy-dotnet.nvim',
    enabled = true,
    dependencies = { 'nvim-lua/plenary.nvim', 'folke/snacks.nvim' },
    lazy = true,
    cmd = { 'Dotnet', 'DotnetTest', 'DotnetBuild' },
    ft = { 'cs', 'csproj' },
    config = function()
      require('easy-dotnet').setup()

      vim.keymap.set('n', '<leader>dnd', function()
        vim.cmd 'Dotnet debug default profile'
      end, { nowait = true, desc = 'Start Debugging' })
    end,
  },
}

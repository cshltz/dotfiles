return {
  {
    'sindrets/diffview.nvim',
    enabled = true,
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('diffview').setup {
        enhanced_diff_hl = true,
        view = {
          merge_tool = {
            layout = 'diff3_mixed',
            disable_diagnostics = true,
            winbar_info = true,
          },
        },
        file_panel = {
          listing_style = 'list',
        },
      }
      vim.keymap.set('n', '<leader>td', function()
        if next(require('diffview.lib').views) == nil then
          vim.cmd 'DiffviewOpen'
        else
          vim.cmd 'DiffviewClose'
        end
      end, { desc = 'Difftool' })
    end,
  },
}

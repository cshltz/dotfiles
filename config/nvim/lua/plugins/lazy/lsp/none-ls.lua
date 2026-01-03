return {
    'nvimtools/none-ls.nvim',
    enabled = false,
    events = {},
    config = function()
        local null_ls = require 'null-ls'
        null_ls.setup {
            sources = {
                null_ls.builtins.formatting.stylua,
                null_ls.builtins.formatting.csharpier,
                null_ls.builtins.formatting.prettier,
            },
        }
    end,
}

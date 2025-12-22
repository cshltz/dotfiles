return {
    {
        'nvim-treesitter/nvim-treesitter',
        branch = 'main',
        build = ':TSUpdate',
        event = { 'BufReadPre', 'BufNewFile' },
        config = function()
            ---@param buf integer
            ---@param language string
            local function treesitter_try_attach(buf, language)
                -- check if parser exists and load it
                if not vim.treesitter.language.add(language) then
                    return
                end
                -- enables syntax highlighting and other treesitter features
                vim.treesitter.start(buf, language)

                -- enables treesitter based folds
                -- for more info on folds see `:help folds`
                -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

                -- enables treesitter based indentation
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end

            local available_parsers = require('nvim-treesitter').get_available()
            vim.api.nvim_create_autocmd('FileType', {
                callback = function(args)
                    local buf, filetype = args.buf, args.match
                    local language = vim.treesitter.language.get_lang(filetype)
                    if not language then
                        return
                    end

                    local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

                    if vim.tbl_contains(installed_parsers, language) then
                        treesitter_try_attach(buf, language)
                    elseif vim.tbl_contains(available_parsers, language) then
                        require('nvim-treesitter').install(language):await(function()
                            treesitter_try_attach(buf, language)
                        end)
                    else
                        treesitter_try_attach(buf, language)
                    end
                end,
            })

            local parsers = {
                'bash',
                'c',
                'diff',
                'html',
                'lua',
                'luadoc',
                'markdown',
                'markdown_inline',
                'query',
                'vim',
                'vimdoc',
                'c_sharp',
            }
            require('nvim-treesitter').install(parsers)
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        event = { 'BufReadPre', 'BufNewFile' },
        init = function()
            -- Disable entire built-in ftplugin mappings to avoid conflicts.
            -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
            vim.g.no_plugin_maps = true
        end,
        opts = {
            lookahead = true,
            selection_modes = {
                ['@parameter.outer'] = 'v',
                ['@function.outer'] = 'V'
            },
            include_surrounding_whitespace = false,
        },
        config = function()
            -- keymaps
            local tsselect = require "nvim-treesitter-textobjects.select"
            vim.keymap.set({ "x", "o" }, "am", function()
                tsselect.select_textobject("@function.outer", "textobjects")
            end, { desc = "method" })
            vim.keymap.set({ "x", "o" }, "im", function()
                tsselect.select_textobject("@function.inner", "textobjects")
            end, { desc = "method" })
            vim.keymap.set({ "x", "o" }, "ac", function()
                tsselect.select_textobject("@class.outer", "textobjects")
            end, { desc = "class" })
            vim.keymap.set({ "x", "o" }, "ic", function()
                tsselect.select_textobject("@class.inner", "textobjects")
            end, { desc = "class" })
            -- You can also use captures from other query groups like `locals.scm`
            vim.keymap.set({ "x", "o" }, "as", function()
                tsselect.select_textobject("@local.scope", "locals")
            end, { desc = "scope" })
        end,
    },
    -- {
    --     "nvim-treesitter/nvim-context",
    --     event = { 'BufReadPre', 'BufNewFile' },
    -- },
}

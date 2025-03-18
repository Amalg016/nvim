-- Fuzzy finder
return {
    -- https://github.com/nvim-telescope/telescope.nvim
    'nvim-telescope/telescope.nvim',
    lazy = true,
    branch = '0.1.x',
    dependencies = {
        -- https://github.com/nvim-lua/plenary.nvim
        { 'nvim-lua/plenary.nvim' },
        {
            -- https://github.com/nvim-telescope/telescope-fzf-native.nvim
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make',
            cond = function()
                return vim.fn.executable 'make' == 1
            end,
        },
    },
    defaults = {
        vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--ignore-file',
            '.gitignore'
        },
        file_ignore_patterns = { "^./.git/", "^node_modules/", "^vendor/", ".cache", "%.o", "%.a",
            "%.out", "%.class",
            "%.pdf", "%.mkv", "%.mp4", "%.zip", "*.class" },
        vcs_ignore = true
    },

    opts = {
        defaults = {
            layout_config = {
                vertical = {
                    width = 0.75
                }
            }
        }
    }
}

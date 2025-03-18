return {
    "stevearc/conform.nvim",
    event = { "VeryLazy", 'BufReadPre', "BufNewFile" },
    config = function()
        local conform = require("conform")

        conform.setup({
            formatters_by_ft = {
                javascript = { "prettier" },
                json = { "prettier" }
            },
            format_on_save = {
                lsp_fallback = true,
                async = false,
                timeout_ms = 500
            }
        })
        vim.keymap.set({ "n", "v" }, "<leader>mp", function()
            conform.format({
                lsp_fallback = true,
                async = false,
                timeout_ms = 500
            })
        end, { desc = "Format file or range (in Visual mode)" })
    end,
}

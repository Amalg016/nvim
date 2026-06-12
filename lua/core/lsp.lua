vim.cmd("syntax on")
vim.opt.autocomplete = true
vim.opt.complete = "w,b,u,t"
vim.opt.pumheight = 10

for _, file in ipairs(vim.fn.readdir(vim.fn.stdpath("config") .. "/lsp", [[v:val =~ '\.lua$']])) do
    local lsp_name = (file:gsub("%.lua$", ""))
    vim.lsp.enable(lsp_name)
end

-- Configure native completion options
vim.opt.completeopt = { "menu", "menuone", "noselect", "popup" }
vim.opt.complete = ".,w,b,u,t,o"

-- Enable LSP completion automatically when server attaches
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp_completion", { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, args.data.client_id, args.buf, {
                autotrigger = true,
            })
        end
    end,
})

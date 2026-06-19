return {
    cmd = function(dispatchers)
        local bufname = vim.api.nvim_buf_get_name(0)
        local root_dir = vim.fs.dirname(vim.fs.find({ "pom.xml", "build.gradle", ".git" }, { upward = true, path = bufname })[1]) or vim.fn.getcwd()
        local workspace_folder = vim.fn.expand("~/.cache/jdtls/workspace") .. "/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")
        
        -- Build the command to run the system jdtls launcher
        local cmd = {
            "jdtls",
            "-data",
            workspace_folder,
        }
        
        return vim.lsp.rpc.start(cmd, dispatchers)
    end,
    filetypes = { "java" },
    root_markers = { "pom.xml", "build.gradle", ".git" },
}

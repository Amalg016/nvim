-- java setup
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
local home = os.getenv 'HOME'
local workspace_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local jdtls = require("jdtls")

-- Needed for debugging
local bundles = {
    vim.fn.glob(home ..
        "/.local/share/nvim/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"),
}
-- Needed for running/debugging unit tests
-- vim.list_extend(bundles, vim.split(vim.fn.glob(home .. "/.local/share/nvim/mason/share/java-test/*.jar", 1), "\n"))


local config = {
    -- The command that starts the language server
    -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
    cmd = {
        'java',
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        -- '-Dosgi.requiredJavaVersion=11',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.level=ALL',
        '-noverify',
        '-Xmx4G',
        '--add-modules=ALL-SYSTEM',
        --'--add-modules=java.base,java.logging,java.sql,java.xml,java.desktop,java.management,java.naming,java.rmi,java.scripting,java.security.jgss,java.security.sasl,java.sql.rowset,java.transaction.xa,java.xml.bind,java.xml.crypto,jdk.httpserver,jdk.unsupported,jdk.zipfs',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
        '-jar', home .. '/.cache/nvim/nvim_lsp/jdtls/plugins/org.eclipse.equinox.launcher_1.5.700.v20200207-2156.jar',
        '-configuration', home .. '/.cache/nvim/nvim_lsp/jdtls/config_mac',
        '-data', vim.fn.expand('~/.cache/jdtls-workspace-') .. workspace_dir,
        -- See `data directory configuration` section in the README
    },
    -- One dedicated LSP server & client will be started per unique root_dir
    root_dir = vim.fs.dirname(vim.fs.find({ '.git', 'mvnw', 'gradlew' }, { upward = true })[1]),
    capabilities = lsp_capabilities,
    init_options = {
        bundles = bundles,
        extendedClientCapabilities = jdtls.extendedClientCapabilities,
    },
    settings = {
        java = {
            home = "/opt/homebrew/opt/openjdk@11/bin/java",
            format = {
                enabled = false, -- Disable formatting
            },
            configuration = {
                runtimes = {
                    {
                        name = "JavaSE-11",
                        path = "/Library/Java/JavaVirtualMachines/openjdk-11.jdk/Contents/Home/",
                    },

                },
            },
            inlayHints = {
                parameterNames = {
                    enabled = "literals" -- literals, all , none
                }
            },
            completion = {
                favoriteStaticMembers = {
                    "org.junit.jupiter.api.Assertions.*",
                    "java.util.Objects.requireNonNull",
                    "java.util.Objects.requireNonNullElse",
                    "org.mockito.Mockito.*"
                },
                filteredTypes = {
                    "com.sun.*",
                    "io.micrometer.shaded.*",
                    "java.awt.*",
                    "jdk.*", "sun.*",
                },
            },
        }
    },
}

config['on_attach'] = function(client, bufnr)
    jdtls.setup_dap({ hotcodereplace = 'auto' })
    require("jdtls.dap").setup_dap()
    vim.lsp.inlay_hint.enable(true, { bufnr }) -- Enable inlay hints for the current buffer
end

function run_app(debug)
    if debug then
        vim.cmd('term' .. './gradlew startTomcat -Pdebug=true')
    else
        vim.cmd('term' .. './gradlew startTomcat')
    end
end

-- Debug
vim.keymap.set("n", "<F10>", ':lua run_app(true)<CR>')

-- Run
vim.keymap.set("n", "<F9>", ':lua run_app()<CR>')


--  keymaps
local keymap = vim.keymap

keymap.set("n", '<leader>go', function()
    jdtls.organize_imports();
end)

keymap.set("n", '<leader>gu', function()
    jdtls.update_projects_config();
end)



--TODO Download the jdtls from https://download.eclipse.org/jdtls/milestones/       -0.57 version
-- also download test debug adapter from https://mvnrepository.com/artifact/com.microsoft.java/com.microsoft.java.debug.plugin
jdtls.start_or_attach(config)

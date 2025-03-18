-- Set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap
keymap.set("n", "<leader>kk", ":e ~/.config/nvim/lua/core/keymaps.lua<CR>") -- edit keymaps
-- General keymaps
--keymap.set("i", "jk", "<ESC>") -- exit insert mode with jk
--keymap.set("i", "ii", "<ESC>") -- exit insert mode with ii
keymap.set("n", "gx", ":!open <c-r><c-a><CR>") -- open URL under cursor
-- Split window management
keymap.set("n", "<leader>sv", "<C-w>v")        -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s")        -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=")        -- make split windows equal width
keymap.set("n", "<leader>sx", ":close<CR>")    -- close split window
keymap.set("n", "<C>w", ":q<CR>")              -- close split window

local api = vim.api

api.nvim_set_keymap("n", "-", "<C-w>-5", { noremap = true }) -- make split window height shorter
api.nvim_set_keymap("n", "=", "<C-w>+5", { noremap = true }) -- make split windows height taller
api.nvim_set_keymap("n", ">", "<C-w>>5", { noremap = true }) -- make split windows width bigger
api.nvim_set_keymap("n", "<", "<C-w><5", { noremap = true }) -- make split windows width smaller

-- SwapLines
-- Normal mode mappings
api.nvim_set_keymap('n', '<A-Down>', ':m .+1<CR>==', { noremap = true })
api.nvim_set_keymap('n', '<A-Up>', ':m .-2<CR>==', { noremap = true })

-- Insert mode mappings
api.nvim_set_keymap('i', '<A-Down>', '<Esc>:m .+1<CR>==gi', { noremap = true })
api.nvim_set_keymap('i', '<A-Up>', '<Esc>:m .-2<CR>==gi', { noremap = true })

-- Visual mode mappings
api.nvim_set_keymap('v', '<A-Down>', ':m \'>+1<CR>gv=gv', { noremap = true })
api.nvim_set_keymap('v', '<A-Up>', ':m \'<-2<CR>gv=gv', { noremap = true })


-- Tab management
keymap.set("n", "<leader>to", ":tabnew<CR>")   -- open a new tab
keymap.set("n", "<leader>tx", ":tabclose<CR>") -- close a tab
keymap.set("n", "<Tab>", ":bNext<CR>")         -- Tab for next tab
keymap.set("n", "<S-Tab>", ":bprevious<CR>")   -- Shift + Tab for previous tab

-- Diff keymaps
keymap.set("n", "<leader>cc", ":diffput<CR>")   -- put diff from current to other during diff
keymap.set("n", "<leader>cj", ":diffget 1<CR>") -- get diff from left (local) during merge
keymap.set("n", "<leader>ck", ":diffget 3<CR>") -- get diff from right (remote) during merge
keymap.set("n", "<leader>cn", "]c")             -- next diff hunk
keymap.set("n", "<leader>cp", "[c")             -- previous diff hunk

-- Quickfix keymaps
keymap.set("n", "<leader>qo", ":copen<CR>")  -- open quickfix list
keymap.set("n", "<leader>qq", ":cfirst<CR>") -- jump to first quickfix list item
keymap.set("n", "<leader>qn", ":cnext<CR>")  -- jump to next quickfix list item
keymap.set("n", "<leader>qp", ":cprev<CR>")  -- jump to prev quickfix list item
keymap.set("n", "<leader>ql", ":clast<CR>")  -- jump to last quickfix list item
keymap.set("n", "<leader>qc", ":cclose<CR>") -- close quickfix list

-- Vim-maximizer
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>") -- toggle maximize tab

-- Nvim-tree
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>") -- toggle file explorer
--keymap.set("n", "<leader>ee", ":NvimTreeFocus<CR>") -- toggle focus to file explorer

-- Telescope
keymap.set('n', '<leader>ff', function() require('telescope.builtin').find_files({ previewer = false }) end)
keymap.set('n', '<leader>fw', function()
    require('telescope.builtin').grep_string({ search = vim.fn.input("Grep > ") })
end)
keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, {})
keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, {})
keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, {})
keymap.set('n', '<leader>fs', require('telescope.builtin').current_buffer_fuzzy_find, {})
keymap.set('n', '<leader>fo', require('telescope.builtin').lsp_document_symbols, {})
keymap.set('n', '<leader>fi', require('telescope.builtin').lsp_incoming_calls, {})
keymap.set('n', '<leader>qf', require('telescope.builtin').quickfix, {})
keymap.set('n', '<leader>fm', function() require('telescope.builtin').treesitter({ default_text = ":method:" }) end)

-- Git-blame
keymap.set("n", "<leader>gb", ":GitBlameToggle<CR>") -- toggle git blame
keymap.set("n", "<leader>gm", ":Gvdiffsplit!<CR>")   -- diffsplit for merge
keymap.set("n", "gdh", ":diffget //2<CR>")           -- Choose from left in diffsplit for merge
keymap.set("n", "gdl", ":diffget //3<CR>")           -- Choose from right in diffsplit for merge


keymap.set("n", "<leader>ha", require("harpoon.mark").add_file)
keymap.set("n", "<leader>hh", require("harpoon.ui").toggle_quick_menu)
keymap.set("n", "<leader>h1", function() require("harpoon.ui").nav_file(1) end)
keymap.set("n", "<leader>h2", function() require("harpoon.ui").nav_file(2) end)
keymap.set("n", "<leader>h3", function() require("harpoon.ui").nav_file(3) end)
keymap.set("n", "<leader>h4", function() require("harpoon.ui").nav_file(4) end)
keymap.set("n", "<leader>h5", function() require("harpoon.ui").nav_file(5) end)
keymap.set("n", "<leader>h6", function() require("harpoon.ui").nav_file(6) end)
keymap.set("n", "<leader>h7", function() require("harpoon.ui").nav_file(7) end)
keymap.set("n", "<leader>h8", function() require("harpoon.ui").nav_file(8) end)
keymap.set("n", "<leader>h9", function() require("harpoon.ui").nav_file(9) end)

-- Vim REST Console
keymap.set("n", "<leader>xr", ":call VrcQuery()<CR>") -- Run REST query

-- LSP
keymap.set('n', '<leader>gg', '<cmd>lua vim.lsp.buf.hover()<CR>')
keymap.set('n', '<leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
keymap.set('n', '<leader>gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
keymap.set('n', '<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
keymap.set('n', '<leader>gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
keymap.set('n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>')
keymap.set('n', '<leader>gR', '<cmd>lua vim.lsp.buf.incoming_calls()<CR>')
keymap.set('n', '<leader>gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
keymap.set('n', '<leader>rr', '<cmd>lua vim.lsp.buf.rename()<CR>')
keymap.set('n', '<leader>gf', '<cmd>lua vim.lsp.buf.format({async = true})<CR>')
keymap.set('v', '<leader>gf', '<cmd>lua vim.lsp.buf.format({async = true})<CR>')
keymap.set('n', '<leader>ga', '<cmd>lua vim.lsp.buf.code_action()<CR>')
keymap.set('n', '<leader>gl', '<cmd>lua vim.diagnostic.open_float()<CR>')
keymap.set('n', '<leader>gp', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
keymap.set('n', '<leader>gn', '<cmd>lua vim.diagnostic.goto_next()<CR>')
keymap.set('n', '<leader>tr', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')
keymap.set('i', '<C-Space>', '<cmd>lua vim.lsp.buf.completion()<CR>')

-- Debugging
keymap.set("n", "<leader>bb", "<cmd>lua require'dap'.toggle_breakpoint()<cr>")
keymap.set("n", "<leader>bc", "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>")
keymap.set("n", "<leader>bl", "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>")
keymap.set("n", '<leader>br', "<cmd>lua require'dap'.clear_breakpoints()<cr>")
keymap.set("n", '<leader>ba', '<cmd>Telescope dap list_breakpoints<cr>')
keymap.set("n", "<F8>", "<cmd>lua require'dap'.continue()<cr>")
keymap.set("n", "<F6>", "<cmd>lua require'dap'.step_over()<cr>")
keymap.set("n", "<F5>", "<cmd>lua require'dap'.step_into()<cr>")
keymap.set("n", "<leader>do", "<cmd>lua require'dap'.step_out()<cr>")
keymap.set("n", '<leader>dd', function()
    require('dap').disconnect(); require('dapui').close();
end)
keymap.set("n", '<leader>dt', function()
    require('dap').terminate(); require('dapui').close();
end)
keymap.set("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>")
keymap.set("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>")
keymap.set("n", '<leader>di', function() require "dap.ui.widgets".hover() end)
keymap.set("n", '<leader>d?',
    function()
        local widgets = require "dap.ui.widgets"; widgets.centered_float(widgets.scopes)
    end)
keymap.set("n", '<leader>df', '<cmd>Telescope dap frames<cr>')
keymap.set("n", '<leader>dh', '<cmd>Telescope dap commands<cr>')
keymap.set("n", '<leader>de', function() require('telescope.builtin').diagnostics({ default_text = ":E:" }) end)

-- Unit Test keymaps
keymap.set("n", '<leader>tm', "<cmd>lua require('neotest').run.run()<cr>")
keymap.set("n", '<leader>tM', "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>")
keymap.set("n", '<leader>tc', "<cmd>lua require('neotest').run.run({vim.fn.expand('%')})<cr>")
keymap.set("n", '<leader>tC', "<cmd>lua require('neotest').run.run({vim.fn.expand('%'),strategy='dap'})<cr>")
keymap.set("n", '<leader>ts', "<cmd>lua require('neotest').summary.toggle()<cr>")
keymap.set("n", '<leader>tq', "<cmd>lua require('neotest').run.stop()<cr>")
keymap.set("n", '<leader>to', "<cmd>lua require('neotest').output.open()<cr>")
keymap.set("n", '<leader>tO', "<cmd>lua require('neotest').output.open({ enter=true })<cr>")

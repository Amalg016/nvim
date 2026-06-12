vim.g.mapleader = " "

local function load_nvim_core(coreFile)
	local ok, configs = pcall(require, "core." .. coreFile)
	if not ok then
		vim.notify(configs, vim.log.levels.WARN)
	end
end

-- These modules are not loaded by lazy
for _, file in ipairs(vim.fn.readdir(vim.fn.stdpath("config") .. "/lua/core", [[v:val =~ '\.lua$']])) do
    local config = (file:gsub("%.lua$", ""))
    load_nvim_core(config)
end


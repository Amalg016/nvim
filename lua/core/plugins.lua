-- Standard built-in package manager setup for Neovim 0.12+
-- This module scans all plugin specs in lua/plugins/, normalizes them,
-- registers PackChanged build hooks, loads them via vim.pack.add(),
-- and executes their configurations.

local M = {}

-- Normalize lazy.nvim spec to vim.pack spec
local function normalize_spec(spec)
    if type(spec) == "string" then
        spec = { spec }
    end

    local src = spec.src or spec[1]
    if not src then
        return nil
    end

    -- If shorthand, expand to github URL
    if not src:find("://") and not src:find("^/") and not src:find("^~") then
        src = "https://github.com/" .. src
    end

    local name = spec.name
    if not name then
        name = src:match(".*/([^/]+)$")
        if name then
            name = name:gsub("%.git$", "")
        end
    end

    local version = spec.version or spec.branch
    if type(version) == "string" then
        if version:find("[*><=^~]") then
            local ok, range = pcall(vim.version.range, version)
            if ok then
                version = range
            end
        end
    end

    return {
        src = src,
        name = name,
        version = version,
        dir = spec.dir,
        -- Extra fields for post-load configuration
        config = spec.config,
        opts = spec.opts,
        main = spec.main,
        dependencies = spec.dependencies,
        build = spec.build,
        cond = spec.cond,
    }
end

-- Collect all plugin specs recursively
local specs = {}
local function add_spec(raw_spec)
    if not raw_spec then return end
    if type(raw_spec) == "table" and raw_spec[1] and type(raw_spec[1]) == "table" then
        for _, s in ipairs(raw_spec) do
            add_spec(s)
        end
        return
    end

    local normalized = normalize_spec(raw_spec)
    if not normalized then return end

    if specs[normalized.name] then
        return
    end

    specs[normalized.name] = normalized

    if normalized.dependencies then
        for _, dep in ipairs(normalized.dependencies) do
            add_spec(dep)
        end
    end
end

function M.setup()
    -- Load all specs from lua/plugins directory
    local plugins_dir = vim.fn.stdpath("config") .. "/lua/plugins"
    for _, file in ipairs(vim.fn.readdir(plugins_dir, [[v:val =~ '\.lua$']])) do
        local mod_name = "plugins." .. file:gsub("%.lua$", "")
        local ok, raw_spec = pcall(require, mod_name)
        if ok then
            add_spec(raw_spec)
        end
    end

    -- Register build hooks before adding plugins
    vim.api.nvim_create_autocmd("PackChanged", {
        callback = function(ev)
            local name = ev.data.spec.name
            local kind = ev.data.kind
            local path = ev.data.path

            local spec = specs[name]
            if spec and spec.build and (kind == "install" or kind == "update") then
                if type(spec.build) == "string" then
                    if spec.build:sub(1, 1) == ":" then
                        vim.cmd(spec.build:sub(2))
                    else
                        vim.fn.jobstart(spec.build, { cwd = path })
                    end
                elseif type(spec.build) == "function" then
                    spec.build()
                end
            end
        end,
    })

    -- Compile list of active plugin specifications for vim.pack.add
    local pack_specs = {}
    for _, spec in pairs(specs) do
        local should_load = true
        if spec.cond ~= nil then
            if type(spec.cond) == "function" then
                should_load = spec.cond()
            else
                should_load = spec.cond
            end
        end

        if should_load then
            if spec.dir then
                -- For local directories, append to runtimepath directly if they exist
                if vim.fn.isdirectory(spec.dir) == 1 then
                    vim.opt.rtp:append(spec.dir)
                end
            else
                table.insert(pack_specs, {
                    src = spec.src,
                    name = spec.name,
                    version = spec.version,
                })
            end
        end
    end

    -- Add and install all plugins via the built-in package manager
    if #pack_specs > 0 then
        vim.pack.add(pack_specs, { confirm = false })
    end

    -- Topological sort for running configurations
    local ordered_names = {}
    local visited = {}

    local function visit(name)
        if visited[name] == "visiting" or visited[name] == "visited" then
            return
        end

        visited[name] = "visiting"
        local spec = specs[name]
        if spec and spec.dependencies then
            for _, dep in ipairs(spec.dependencies) do
                local dep_name = normalize_spec(dep).name
                visit(dep_name)
            end
        end
        visited[name] = "visited"
        table.insert(ordered_names, name)
    end

    for name, _ in pairs(specs) do
        visit(name)
    end

    -- Run configurations in order
    for _, name in ipairs(ordered_names) do
        local spec = specs[name]
        local should_load = true
        if spec.cond ~= nil then
            if type(spec.cond) == "function" then
                should_load = spec.cond()
            else
                should_load = spec.cond
            end
        end

        -- Make sure it exists if it's a local dir
        if should_load and spec.dir and vim.fn.isdirectory(spec.dir) ~= 1 then
            should_load = false
        end

        if should_load then
            if spec.config then
                spec.config(spec, spec.opts or {})
            elseif spec.opts then
                -- Try to require and setup with smart naming rules
                local mod_name = spec.main or spec.name:gsub("%.nvim$", ""):gsub("^vim-", ""):gsub("-", "")
                local ok, mod = pcall(require, mod_name)
                if ok and type(mod) == "table" and mod.setup then
                    mod.setup(spec.opts)
                else
                    mod_name = spec.main or spec.name:gsub("%.nvim$", ""):gsub("^vim-", "")
                    ok, mod = pcall(require, mod_name)
                    if ok and type(mod) == "table" and mod.setup then
                        mod.setup(spec.opts)
                    end
                end
            end
        end
    end
end

M.setup()

return M

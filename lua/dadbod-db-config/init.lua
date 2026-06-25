local M = {}

local defaults = {
    auto_load = true,
}

---@brief
--- Load a project-local `.dbs.lua` file for vim-dadbod.

--- Configure dadbod-db-config.nvim.
---@param opts? table
---@return table? result load result when auto_load is enabled
function M.setup(opts)
    M.opts = vim.tbl_extend("force", defaults, opts or {})

    if M.opts.auto_load then
        return M.load()
    end
end

--- Load the project-local dadbod database config.
---@return table result load result
function M.load()
    local root = vim.fs.root(0, {
        ".dbs.lua",
    })

    if not root then
        return {
            loaded = false,
            reason = "not_found",
        }
    end

    local path = vim.fs.joinpath(root, ".dbs.lua")
    dofile(path)

    return {
        loaded = true,
        path = path,
        root = root,
    }
end

return M

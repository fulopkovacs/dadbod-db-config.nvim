local M = {}

---@brief
--- Load a project-local `.dbs.lua` file for vim-dadbod.

--- Configure dadbod-db-config.nvim.
---@param opts? table
function M.setup(opts)
    M.opts = opts or {}
end

--- Load the project-local dadbod database config.
---@return table result load result
function M.load()
    return {
        loaded = false,
        reason = "not_implemented",
    }
end

return M

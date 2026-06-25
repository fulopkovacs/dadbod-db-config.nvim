local M = {}

local config_filename = ".dbs.json"

---@brief
--- Load a project-local `.dbs.json` file for vim-dadbod.

local function decode_json(path)
    local content = table.concat(vim.fn.readfile(path), "\n")
    local ok, decoded = pcall(vim.json.decode, content)

    if not ok then
        return nil
    end

    return decoded
end

local function is_valid_config(config)
    return type(config) == "table" and type(config.dbs) == "table" and vim.islist(config.dbs)
end

--- Load the project-local dadbod database config.
---@return table result load result
function M.load()
    local root = vim.fs.root(0, {
        config_filename,
    })

    if not root then
        return {
            loaded = false,
            reason = "not_found",
        }
    end

    local path = vim.fs.joinpath(root, config_filename)
    local config = decode_json(path)

    if not config then
        return {
            loaded = false,
            path = path,
            root = root,
            reason = "invalid_json",
        }
    end

    if not is_valid_config(config) then
        return {
            loaded = false,
            path = path,
            root = root,
            reason = "invalid_config",
        }
    end

    vim.g.dbs = config.dbs

    return {
        loaded = true,
        dbs = config.dbs,
        path = path,
        root = root,
    }
end

return M

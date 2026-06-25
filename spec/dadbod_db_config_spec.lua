local db_config = require("dadbod-db-config")

describe("dadbod-db-config", function()
    local temp_dir

    local function path(...)
        return vim.fs.joinpath(temp_dir, ...)
    end

    local function write_file(file_path, lines)
        vim.fn.mkdir(vim.fs.dirname(file_path), "p")
        vim.fn.writefile(lines, file_path)
    end

    local function edit_file(file_path)
        write_file(file_path, {
            "",
        })
        vim.cmd.edit(vim.fn.fnameescape(file_path))
    end

    before_each(function()
        temp_dir = vim.fn.tempname()
        vim.fn.mkdir(temp_dir, "p")
        temp_dir = vim.fn.resolve(temp_dir)
        vim.g.dadbod_db_config_test_value = nil
    end)

    after_each(function()
        pcall(vim.cmd, "silent! bwipe!")
        vim.fn.delete(temp_dir, "rf")
        vim.g.dadbod_db_config_test_value = nil
    end)

    it("loads the module", function()
        assert.is_function(db_config.setup)
        assert.is_function(db_config.load)
    end)

    it("returns not_found when no .dbs.lua exists", function()
        edit_file(path("project", "src", "query.sql"))

        assert.are.same({
            loaded = false,
            reason = "not_found",
        }, db_config.load())
        assert.is_nil(vim.g.dadbod_db_config_test_value)
    end)

    it("loads .dbs.lua from the nearest project root", function()
        local project_root = path("project")
        local dbs_path = vim.fs.joinpath(project_root, ".dbs.lua")

        write_file(dbs_path, {
            "vim.g.dadbod_db_config_test_value = 'project'",
        })
        edit_file(path("project", "src", "query.sql"))

        assert.are.same({
            loaded = true,
            path = dbs_path,
            root = project_root,
        }, db_config.load())
        assert.are.equal("project", vim.g.dadbod_db_config_test_value)
    end)

    it("uses the nearest .dbs.lua in monorepo-style layouts", function()
        local repo_root = path("repo")
        local app_root = path("repo", "apps", "api")
        local app_dbs_path = vim.fs.joinpath(app_root, ".dbs.lua")

        write_file(vim.fs.joinpath(repo_root, ".dbs.lua"), {
            "vim.g.dadbod_db_config_test_value = 'repo'",
        })
        write_file(app_dbs_path, {
            "vim.g.dadbod_db_config_test_value = 'api'",
        })
        edit_file(path("repo", "apps", "api", "src", "query.sql"))

        assert.are.same({
            loaded = true,
            path = app_dbs_path,
            root = app_root,
        }, db_config.load())
        assert.are.equal("api", vim.g.dadbod_db_config_test_value)
    end)

    it("setup auto-loads by default", function()
        write_file(path("project", ".dbs.lua"), {
            "vim.g.dadbod_db_config_test_value = 'auto'",
        })
        edit_file(path("project", "src", "query.sql"))

        local result = db_config.setup()

        assert.is_true(result.loaded)
        assert.are.equal("auto", vim.g.dadbod_db_config_test_value)
    end)

    it("setup can skip auto-loading", function()
        write_file(path("project", ".dbs.lua"), {
            "vim.g.dadbod_db_config_test_value = 'skip'",
        })
        edit_file(path("project", "src", "query.sql"))

        assert.is_nil(db_config.setup({
            auto_load = false,
        }))
        assert.is_nil(vim.g.dadbod_db_config_test_value)
    end)
end)

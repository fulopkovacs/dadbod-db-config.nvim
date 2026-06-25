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

    local function write_config(file_path, name, url)
        write_file(file_path, {
            "{",
            "  \"dbs\": [",
            "    {",
            string.format("      \"name\": \"%s\",", name),
            string.format("      \"url\": \"%s\"", url),
            "    }",
            "  ]",
            "}",
        })
    end

    before_each(function()
        temp_dir = vim.fn.tempname()
        vim.fn.mkdir(temp_dir, "p")
        temp_dir = vim.fn.resolve(temp_dir)
        vim.g.dbs = nil
    end)

    after_each(function()
        pcall(vim.cmd, "silent! bwipe!")
        vim.fn.delete(temp_dir, "rf")
        vim.g.dbs = nil
    end)

    it("loads the module", function()
        assert.is_function(db_config.setup)
        assert.is_function(db_config.load)
    end)

    it("returns not_found when no .dbs.json exists", function()
        edit_file(path("project", "src", "query.sql"))

        assert.are.same({
            loaded = false,
            reason = "not_found",
        }, db_config.load())
        assert.is_nil(vim.g.dbs)
    end)

    it("loads .dbs.json from the nearest project root", function()
        local project_root = path("project")
        local dbs_path = vim.fs.joinpath(project_root, ".dbs.json")
        local dbs = {
            {
                name = "project",
                url = "sqlite:project.sqlite",
            },
        }

        write_config(dbs_path, "project", "sqlite:project.sqlite")
        edit_file(path("project", "src", "query.sql"))

        assert.are.same({
            dbs = dbs,
            loaded = true,
            path = dbs_path,
            root = project_root,
        }, db_config.load())
        assert.are.same(dbs, vim.g.dbs)
    end)

    it("uses the nearest .dbs.json in monorepo-style layouts", function()
        local repo_root = path("repo")
        local app_root = path("repo", "apps", "api")
        local app_dbs_path = vim.fs.joinpath(app_root, ".dbs.json")
        local dbs = {
            {
                name = "api",
                url = "sqlite:api.sqlite",
            },
        }

        write_config(vim.fs.joinpath(repo_root, ".dbs.json"), "repo", "sqlite:repo.sqlite")
        write_config(app_dbs_path, "api", "sqlite:api.sqlite")
        edit_file(path("repo", "apps", "api", "src", "query.sql"))

        assert.are.same({
            dbs = dbs,
            loaded = true,
            path = app_dbs_path,
            root = app_root,
        }, db_config.load())
        assert.are.same(dbs, vim.g.dbs)
    end)

    it("returns invalid_json when .dbs.json cannot be decoded", function()
        local project_root = path("project")
        local dbs_path = vim.fs.joinpath(project_root, ".dbs.json")

        write_file(dbs_path, {
            "{ invalid json",
        })
        edit_file(path("project", "src", "query.sql"))

        assert.are.same({
            loaded = false,
            path = dbs_path,
            reason = "invalid_json",
            root = project_root,
        }, db_config.load())
        assert.is_nil(vim.g.dbs)
    end)

    it("returns invalid_config when dbs is missing", function()
        local project_root = path("project")
        local dbs_path = vim.fs.joinpath(project_root, ".dbs.json")

        write_file(dbs_path, {
            "{}",
        })
        edit_file(path("project", "src", "query.sql"))

        assert.are.same({
            loaded = false,
            path = dbs_path,
            reason = "invalid_config",
            root = project_root,
        }, db_config.load())
        assert.is_nil(vim.g.dbs)
    end)

    it("setup auto-loads by default", function()
        write_config(path("project", ".dbs.json"), "auto", "sqlite:auto.sqlite")
        edit_file(path("project", "src", "query.sql"))

        local result = db_config.setup()

        assert.is_true(result.loaded)
        assert.are.same({
            {
                name = "auto",
                url = "sqlite:auto.sqlite",
            },
        }, vim.g.dbs)
    end)

    it("setup can skip auto-loading", function()
        write_config(path("project", ".dbs.json"), "skip", "sqlite:skip.sqlite")
        edit_file(path("project", "src", "query.sql"))

        assert.is_nil(db_config.setup({
            auto_load = false,
        }))
        assert.is_nil(vim.g.dbs)
    end)
end)

if vim.g.loaded_dadbod_db_config then
    return
end

vim.g.loaded_dadbod_db_config = true

vim.api.nvim_create_user_command("DadbodDbConfigLoad", function()
    require("dadbod-db-config").load()
end, {})

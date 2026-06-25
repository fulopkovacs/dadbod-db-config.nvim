local db_config = require("dadbod-db-config")

describe("dadbod-db-config", function()
    it("loads the module", function()
        assert.is_function(db_config.setup)
        assert.is_function(db_config.load)
    end)
end)

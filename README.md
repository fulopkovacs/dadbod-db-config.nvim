# dadbod-db-config.nvim

Load a project-local `.dbs.lua` file for vim-dadbod.

The plugin searches upward from the current buffer for the nearest `.dbs.lua`
file using `vim.fs.root()`. If it finds one, it executes that file with
`dofile()`.

This works well in monorepos: the nearest `.dbs.lua` wins.

## Requirements

- Neovim with `vim.fs.root()` support
- [tpope/vim-dadbod](https://github.com/tpope/vim-dadbod)
- [kristijanhusak/vim-dadbod-ui](https://github.com/kristijanhusak/vim-dadbod-ui)

## Installation

With [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    "dadbod-db-config.nvim",
    dependencies = {
        "tpope/vim-dadbod",
        "kristijanhusak/vim-dadbod-ui",
    },
    config = function()
        require("dadbod-db-config").setup()
    end,
}
```

For local development with `dev = true`:

```lua
{
    "dadbod-db-config.nvim",
    dev = true,
    dependencies = {
        "tpope/vim-dadbod",
        "kristijanhusak/vim-dadbod-ui",
    },
    config = function()
        require("dadbod-db-config").setup()
    end,
}
```

## Usage

Create a `.dbs.lua` file in your project:

```lua
local dbs = {
    {
        name = "opera-data-collection-scripts",
        url = "sqlite:local.sqlite",
    },
}

vim.api.nvim_set_var("dbs", dbs)
```

By default, `setup()` loads the nearest `.dbs.lua` immediately:

```lua
require("dadbod-db-config").setup()
```

To configure the plugin without loading immediately:

```lua
require("dadbod-db-config").setup({
    auto_load = false,
})
```

Load or reload manually:

```vim
:DadbodDbConfigLoad
```

Or from Lua:

```lua
require("dadbod-db-config").load()
```

`load()` returns a result table:

```lua
{
    loaded = true,
    path = "/path/to/project/.dbs.lua",
    root = "/path/to/project",
}
```

When no `.dbs.lua` is found:

```lua
{
    loaded = false,
    reason = "not_found",
}
```

## Security

`.dbs.lua` is executable Lua. Only use this plugin in projects where you trust
the `.dbs.lua` file.

## Development

Run tests:

```sh
make test
```

Check formatting:

```sh
make format-check
```

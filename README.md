# dadbod-db-config.nvim

Load a project-local `.dbs.json` file for [vim-dadbod](https://github.com/tpope/vim-dadbod).

The plugin searches upward from the current buffer for the nearest `.dbs.json`
file using `vim.fs.root()`. If it finds one, it reads the database connections
from JSON and sets `vim.g.dbs` for [vim-dadbod-ui](https://github.com/kristijanhusak/vim-dadbod-ui).

This works well in monorepos: the nearest `.dbs.json` wins.

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
}
```

## Usage

Create a `.dbs.json` file in your project:

```json
{
  "$schema": "https://raw.githubusercontent.com/fulopkovacs/dadbod-db-config.nvim/main/schemas/dbs.schema.json",
  "dbs": [
    {
      "name": "opera-data-collection-scripts",
      "url": "sqlite:local.sqlite"
    }
  ]
}
```

The plugin loads the nearest `.dbs.json` automatically when it is loaded.

Load or reload manually:

```vim
:DadbodDbConfigLoad
```

Or from Lua:

```lua
require("dadbod-db-config").load()
```

## Schema

The JSON schema is available at:

```text
https://raw.githubusercontent.com/fulopkovacs/dadbod-db-config.nvim/main/schemas/dbs.schema.json
```

Use it in `.dbs.json` with:

```json
{
  "$schema": "https://raw.githubusercontent.com/fulopkovacs/dadbod-db-config.nvim/main/schemas/dbs.schema.json",
  "dbs": []
}
```

Each database entry requires `name` and `url`. Additional properties are allowed
on entries so dadbod-related metadata can be added later.

Example config:

```json
{
  "$schema": "https://raw.githubusercontent.com/fulopkovacs/dadbod-db-config.nvim/main/schemas/dbs.schema.json",
  "dbs": [
    {
      "name": "opera-database",
      "url": "sqlite:opera-db.sqlite"
    }
  ]
}
```

## Development

Run tests:

```sh
make test
```

Check formatting:

```sh
make format-check
```

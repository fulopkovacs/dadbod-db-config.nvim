# dadbod-db-config.nvim

Load a project-local `.dbs.json` file for [vim-dadbod-ui](https://github.com/kristijanhusak/vim-dadbod-ui).

The plugin searches upward from the current buffer for the nearest `.dbs.json`
file using `vim.fs.root()`. If it finds one, it reads the database connections
from JSON and sets `vim.g.dbs` for [vim-dadbod-ui](https://github.com/kristijanhusak/vim-dadbod-ui).

This works well in monorepos: the nearest `.dbs.json` wins.

## Motivation

I wanted an easy, well-structured way to define project-level database connections.

`vim-dadbod-ui` gives you 3 ways to do this:

- [using environment variables](https://github.com/kristijanhusak/vim-dadbod-ui#through-environment-variables)
- [the `DBUIAddConnection` command](https://github.com/kristijanhusak/vim-dadbod-ui#via-dbuiaddconnection-command)
- [manually setting the `g:dbs` global variable](https://github.com/kristijanhusak/vim-dadbod-ui#via-gdbs-global-variable)

The docs mention that you can use the last option in project-local Vim configs.

I wasn't satisfied with any of these solutions, so I created a new approach:

- single-purpose config files, not general Neovim config
- easy validation with JSON schemas

## Requirements

- Neovim version `0.10.0` or higher
- [tpope/vim-dadbod](https://github.com/tpope/vim-dadbod)
- [kristijanhusak/vim-dadbod-ui](https://github.com/kristijanhusak/vim-dadbod-ui)

## Installation

With [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
        "tpope/vim-dadbod",
        "fulopkovacs/dadbod-db-config.nvim",
    },
}
```

For local development with `dev = true`:

```lua
{
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
        "tpope/vim-dadbod",
        {
            "fulopkovacs/dadbod-db-config.nvim",
            dev = true,
        },
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

Add `.dbs.json` to your project's `.gitignore`, since it may contain local database URLs or credentials.

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

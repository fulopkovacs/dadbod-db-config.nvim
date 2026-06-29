# Changelog

## [1.0.1] - 2026-06-30

### Changed

- Clarify the motivation for project-local `.dbs.json` config files.
- Update the lazy.nvim installation example to load this plugin as a dependency of `vim-dadbod-ui`.
- Document that `.dbs.json` should be added to `.gitignore` because it may contain local database URLs or credentials.

## [1.0.0] - 2026-06-28

Initial release.

### Added

- Load project-local `.dbs.json` files for `vim-dadbod`.
- Search upward from the current buffer and use the nearest `.dbs.json`.
- Populate `vim.g.dbs` for `vim-dadbod-ui`.
- Add `:DadbodDbConfigLoad` for manual loading/reloading.
- Expose `require("dadbod-db-config").load()` for Lua usage.
- Add a JSON schema for `.dbs.json` files.

# Changelog

## [1.0.0] - 2026-06-28

Initial release.

### Added

- Load project-local `.dbs.json` files for `vim-dadbod`.
- Search upward from the current buffer and use the nearest `.dbs.json`.
- Populate `vim.g.dbs` for `vim-dadbod-ui`.
- Add `:DadbodDbConfigLoad` for manual loading/reloading.
- Expose `require("dadbod-db-config").load()` for Lua usage.
- Add a JSON schema for `.dbs.json` files.

local _log = require("graphDaCode.log")
local _symbol = require("symbols")
---@class graphDaCode
local M = {}

---TODO: Implement query on fzf
M.get_lsp_info_for_symbol = function()
  local params = vim.lsp.util.make_position_params()
  local clients = vim.lsp.buf_get_clients()
  local Symbol = _symbol.get_symbols_at_cursor()
  local CurSymbol = Symbol[1]
  -- Check if there are any active LSP clients
  if #clients == 0 then
    vim.notify("No active LSP client for the current buffer.", vim.log.levels.INFO)
    return
  end
  local client = client
end
---TODO: Parse to d2
M.parse_to_d2 = function() end

return M

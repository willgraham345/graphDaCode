local _log = require("graphDaCode.log")
-- local _symbol = require("symbols") -- This module is not available in the project
---@class graphDaCode
local M = {}

local symbol_kind_to_plantuml = {
  [vim.lsp.protocol.SymbolKind.Class] = "class",
  [vim.lsp.protocol.SymbolKind.Interface] = "interface",
  [vim.lsp.protocol.SymbolKind.Struct] = "struct",
}

local function get_plantuml_keyword(symbol_kind)
  return symbol_kind_to_plantuml[symbol_kind] or "object"
end

---TODO: Implement query on fzf
M.get_lsp_info_for_symbol = function()
  local params = vim.lsp.util.make_position_params()
  local clients = vim.lsp.buf_get_clients()
  -- local Symbol = _symbol.get_symbols_at_cursor() -- This module is not available in the project
  -- local CurSymbol = Symbol[1]
  -- Check if there are any active LSP clients
  if #clients == 0 then
    vim.notify("No active LSP client for the current buffer.", vim.log.levels.INFO)
    return
  end
  local client = client
end

M.get_definition_plantuml = function()
  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf.document_symbol(params.textDocument.uri, function(err, symbols)
    if err or not symbols then
      vim.notify("LSP error: " .. tostring(err), vim.log.levels.ERROR)
      return
    end

    local cursor_pos = params.position
    local current_symbol

    local function find_symbol(symbols_list, pos)
      for _, symbol in ipairs(symbols_list) do
        local s_range = symbol.selectionRange or symbol.range
        if pos.line >= s_range.start.line and pos.line <= s_range.end.line and pos.character >= s_range.start.character and pos.character <= s_range.end.character then
          if symbol.children then
            local child = find_symbol(symbol.children, pos)
            if child then
              return child
            end
          end
          return symbol
        end
      end
    end

    current_symbol = find_symbol(symbols, cursor_pos)

    if not current_symbol then
      vim.notify("No symbol found at cursor", vim.log.levels.INFO)
      return
    end

    vim.lsp.buf.definition(params, function(err, result)
      if err then
        vim.notify("LSP error: " .. tostring(err), vim.log.levels.ERROR)
        return
      end

      if result and not vim.tbl_isempty(result) then
        local plantuml = { "@startuml" }
        local plantuml_keyword = get_plantuml_keyword(current_symbol.kind)
        table.insert(plantuml, string.format('%s "%s"', plantuml_keyword, current_symbol.name))
        table.insert(plantuml, "@enduml")
        print(table.concat(plantuml, "\n"))
      else
        vim.notify("No definition found", vim.log.levels.INFO)
      end
    end)
  end)
end

M.get_implementations_plantuml = function(opts)
  opts = opts or {}
  local level = opts.level or 1

  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf.implementation(params, function(err, result)
    if err then
      vim.notify("LSP error: " .. tostring(err), vim.log.levels.ERROR)
      return
    end

    if result and not vim.tbl_isempty(result) then
      local plantuml = { "@startuml" }
      local symbol_name = vim.fn.expand("<cword>")
      table.insert(plantuml, string.format('object "%s"', symbol_name))

      if level == 1 then
        for i, item in ipairs(result) do
          local filename = vim.fn.fnamemodify(item.uri, ":t")
          table.insert(plantuml, string.format('object "%s" as impl%d', filename, i))
          table.insert(plantuml, string.format('"%s" --|> impl%d', symbol_name, i))
        end
        table.insert(plantuml, "@enduml")
        print(table.concat(plantuml, "\n"))
      elseif level >= 2 then
        local implementations = {}
        local count = #result
        for i, item in ipairs(result) do
          vim.lsp.buf.document_symbol(item.uri, function(err, symbols)
            if err or not symbols then
              count = count - 1
              return
            end

            local function find_symbol_at_range(symbols_list, range)
              for _, symbol in ipairs(symbols_list) do
                if symbol.range.start.line == range.start.line and symbol.range.start.character == range.start.character then
                  return symbol
                end
                if symbol.children then
                  local found = find_symbol_at_range(symbol.children, range)
                  if found then
                    return found
                  end
                end
              end
            end

            local impl_symbol = find_symbol_at_range(symbols, item.range)

            if impl_symbol then
              table.insert(implementations, { name = impl_symbol.name, kind = impl_symbol.kind })
            end

            count = count - 1
            if count == 0 then
              for i, impl in ipairs(implementations) do
                local keyword = "object"
                if level == 3 then
                  keyword = get_plantuml_keyword(impl.kind)
                end
                table.insert(plantuml, string.format('%s "%s" as impl%d', keyword, impl.name, i))
                table.insert(plantuml, string.format('"%s" --|> impl%d', symbol_name, i))
              end
              table.insert(plantuml, "@enduml")
              print(table.concat(plantuml, "\n"))
            end
          end)
        end
      end
    else
      vim.notify("No implementation found", vim.log.levels.INFO)
    end
  end)
end

---TODO: Parse to d2
M.parse_to_d2 = function() end

return M

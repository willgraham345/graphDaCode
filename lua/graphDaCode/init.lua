---@type table<string, boolean>
local cmds = {}

---@param name string
---@param cmd fun(t: table)
---@param opts table
local function create_user_command(name, cmd, opts)
  cmds[name] = true
  vim.api.nvim_create_user_command(name, cmd, opts)
end

local function setup(opts)
  opts = opts or {}
  create_user_command("GraphSymbol", require("graphDaCode.graphDaCode").get_lsp_info_for_symbol, {
    desc = "Graph the symbol under the cursor",
  })
  create_user_command("GraphDefinition", require("graphDaCode.graphDaCode").get_definition_plantuml, {
    desc = "Graph the definition of the symbol under the cursor",
  })
  create_user_command("GraphImplementations", function(args)
    require("graphDaCode.graphDaCode").get_implementations_plantuml({ level = tonumber(args.fargs[1]) or 1 })
  end, {
    desc = "Graph the implementations of the symbol under the cursor",
    nargs = "?",
  })
end

return {
  setup = setup,
}
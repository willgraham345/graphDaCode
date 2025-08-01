Symbol = {}

local function create_user_command(name, cmd, opts)
  cmds[name] = true
  vim.api.nvim_create_user_command(name, command, opts)
end

---@type table<string, boolean>
local cmds = {}

---@param name string
---@param cmd fun(t: table)
---@param opts table
local function create_user_command(name, cmd, opts)
  cmds[name] = true
  vim.api.nvim_create_user_command(name, cmd, opts)
end

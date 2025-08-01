local M = {}

M.DEFAULT_LOG_LEVEL = vim.log.levels.ERROR
M.LOG_LEVEL = M.DEFAULT_LOG_LEVEL

-- A simple logger module to replace debug statements.
local logger = {}
local enabled = true
local level = "DEBUG" -- Default log level
local levels = {
  DEBUG = 1,
  INFO = 2,
  WARN = 3,
  ERROR = 4,
}

--- Logs a message if logging is enabled and the message's level is sufficient.
--- @param msg_level string The level of the message (e.g., "DEBUG", "INFO").
--- @param msg string The message to log.
local function log(msg_level, msg)
  if enabled and levels[msg_level] and levels[msg_level] >= levels[level] then
    vim.api.nvim_echo({ { "[" .. msg_level .. "] " .. msg, "None" } }, true, {})
  end
end

logger.debug = function(msg)
  log("DEBUG", msg)
end
logger.info = function(msg)
  log("INFO", msg)
end
logger.warn = function(msg)
  log("WARN", msg)
end
logger.error = function(msg)
  log("ERROR", msg)
end

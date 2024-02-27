local M = {}

---@param filename string
---@return table | nil
function M.read_json_file(filename)
  local Path = require "plenary.path"

  local path = Path:new(filename)
  if not path:exists() then return nil end

  local json_contents = path:read()
  local json = vim.fn.json_decode(json_contents)

  return json
end

function M.read_package_json() return M.read_json_file "package.json" end

---Check if the given NPM package is installed in the current project.
---@param package string
---@return boolean
function M.is_npm_package_installed(package)
  local package_json = M.read_package_json()
  if not package_json then return false end

  if package_json.dependencies and package_json.dependencies[package] then return true end

  if package_json.devDependencies and package_json.devDependencies[package] then return true end

  return false
end

return M

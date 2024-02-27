-- https://github.com/johnsoncodehk/volar
local util = require "lspconfig.util"
local is_npm_package_installed = require("utils").is_npm_package_installed

---@param root_dir string
---@return string|nil
local function get_typescript_server_path(root_dir)
  local found_ts = ""
  local function check_dir(path)
    found_ts = util.path.join(path, "node_modules", "typescript", "lib")
    if util.path.exists(found_ts) then return path end
  end

  if util.search_ancestors(root_dir, check_dir) then return found_ts end

  return nil
end

local filetypes = { "vue" }
if is_npm_package_installed "vue" then filetypes = { "vue", "typescript", "javascript", "typescriptreact" } end

require("lspconfig").volar.setup {
  capabilities = require "plugins.lsp.capabilities",
  filetypes = filetypes,
  on_new_config = function(new_config, new_root_dir)
    new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
  end,
  init_options = {
    configFiles = {
      vetur = {
        useWorkspaceDependencies = true,
        validation = {
          template = true,
          style = true,
          script = true,
          templateProps = true,
        },
        completion = {
          autoImport = true,
          tagCasing = "kebab",
          scaffoldSnippetSources = {
            workspace = true,
            user = true,
          },
        },
      },
    },
  },
}

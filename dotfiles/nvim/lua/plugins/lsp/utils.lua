local M = {}

--- Get the URI from a Location or LocationLink
---@param item lsp.Location|lsp.LocationLink
---@return string|nil
local function get_uri(item)
  return item.targetUri or item.uri
end

--- Filter out .d.ts files when a corresponding .ts source exists
---@param results (lsp.Location|lsp.LocationLink)[]
---@return (lsp.Location|lsp.LocationLink)[]
local function filter_dts_files(results)
  local dominated_by_source = {}

  -- First pass: identify which .d.ts files have corresponding .ts sources
  for _, item in ipairs(results) do
    local uri = get_uri(item)
    if uri and uri:match("%.ts$") and not uri:match("%.d%.ts$") then
      -- This is a .ts source file, mark its .d.ts equivalent as dominated
      local dts_uri = uri:gsub("%.ts$", ".d.ts")
      dominated_by_source[dts_uri] = true
    end
  end

  -- Second pass: filter out .d.ts files that have source equivalents
  local filtered = vim.tbl_filter(function(item)
    local uri = get_uri(item)
    if not uri then return true end

    -- If this is a .d.ts and we have its source, skip it
    if uri:match("%.d%.ts$") and dominated_by_source[uri] then
      return false
    end

    return true
  end, results)

  return #filtered > 0 and filtered or results
end

--- Filter out node_modules, but preserve workspace packages
--- Workspace packages in node_modules are usually symlinks to local packages
---@param results (lsp.Location|lsp.LocationLink)[]
---@return (lsp.Location|lsp.LocationLink)[]
local function filter_external_modules(results)
  local dominated_by_local = false

  -- Check if we have any non-node_modules results
  for _, item in ipairs(results) do
    local uri = get_uri(item)
    if uri and not uri:match("node_modules") then
      dominated_by_local = true
      break
    end
  end

  -- Only filter if we have local alternatives
  if not dominated_by_local then
    return results
  end

  local filtered = vim.tbl_filter(function(item)
    local uri = get_uri(item)
    if not uri then return true end
    return not uri:match("node_modules")
  end, results)

  return #filtered > 0 and filtered or results
end

--- Filter out results pointing to the same location as cursor
---@param results (lsp.Location|lsp.LocationLink)[]
---@return (lsp.Location|lsp.LocationLink)[]
local function filter_same_location(results)
  return vim.tbl_filter(function(item)
    local from = item.originSelectionRange
    local to = item.targetSelectionRange or item.range

    if not from or not to then return true end

    return not (
      from.start.character == to.start.character
      and from.start.line == to.start.line
      and from["end"].character == to["end"].character
      and from["end"].line == to["end"].line
    )
  end, results)
end

--- Smart go-to-definition that filters unhelpful results
--- Prefers source .ts files over .d.ts, local code over node_modules
function M.list_or_jump(action, title, options)
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local make_entry = require("telescope.make_entry")

  options = options or {}

  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request(0, action, params, function(err, result, ctx)
    if err then
      vim.api.nvim_err_writeln("Error when executing " .. action .. " : " .. err.message)
      return
    end

    local flattened_results = {}
    if result then
      -- textDocument/definition can return Location or Location[]
      if vim.islist(result) then
        flattened_results = result
      else
        flattened_results = { result }
      end
    end

    -- Apply filters: prefer .ts over .d.ts, local over node_modules
    flattened_results = filter_same_location(flattened_results)
    flattened_results = filter_dts_files(flattened_results)
    flattened_results = filter_external_modules(flattened_results)

    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if not client then return end
    local offset_encoding = client.offset_encoding

    if #flattened_results == 0 then
      vim.notify("No definitions found", vim.log.levels.INFO)
      return
    elseif #flattened_results == 1 and options.jump_type ~= "never" then
      local uri = params.textDocument.uri
      local target_uri = get_uri(flattened_results[1])

      if uri ~= target_uri then
        if options.jump_type == "tab" then
          vim.cmd.tabedit()
        elseif options.jump_type == "split" then
          vim.cmd.new()
        elseif options.jump_type == "vsplit" then
          vim.cmd.vnew()
        elseif options.jump_type == "tab drop" and target_uri then
          local file_path = vim.uri_to_fname(target_uri)
          vim.cmd("tab drop " .. file_path)
        end
      end

      vim.lsp.util.jump_to_location(flattened_results[1], offset_encoding, options.reuse_win)
    else
      local locations = vim.lsp.util.locations_to_items(flattened_results, offset_encoding)
      pickers
        .new(options, {
          prompt_title = title,
          finder = finders.new_table({
            results = locations,
            entry_maker = options.entry_maker or make_entry.gen_from_quickfix(options),
          }),
          previewer = conf.qflist_previewer(options),
          sorter = conf.generic_sorter(options),
          push_cursor_on_edit = true,
          push_tagstack_on_edit = true,
        })
        :find()
    end
  end)
end

return M

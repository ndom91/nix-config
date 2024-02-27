local M = {}

---@param results lsp.LocationLink[]
---@return lsp.LocationLink[]
local function filter_out_libraries_from_lsp_items(results)
  local without_node_modules = vim.tbl_filter(
    function(item) return item.targetUri and not string.match(item.targetUri, "node_modules") end,
    results
  )

  if #without_node_modules > 0 then return without_node_modules end

  return results
end

---@param results lsp.LocationLink[]
---@return lsp.LocationLink[]
local function filter_out_same_location_from_lsp_items(results)
  return vim.tbl_filter(function(item)
    local from = item.originSelectionRange
    local to = item.targetSelectionRange

    return not (
      from
      and from.start.character == to.start.character
      and from.start.line == to.start.line
      and from["end"].character == to["end"].character
      and from["end"].line == to["end"].line
    )
  end, results)
end

-- Designed to skip jumping to definitions found in node_modules instead
-- of the correct definition somewhere else in your codebase.
--
-- This function is mostly copied from Telescope, I only added the
-- `node_modules` filtering.
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
      if not vim.tbl_islist(result) then flattened_results = { result } end

      vim.list_extend(flattened_results, result)
    end

    -- This is the only added step to the Telescope function
    flattened_results = filter_out_same_location_from_lsp_items(filter_out_libraries_from_lsp_items(flattened_results))

    local offset_encoding = vim.lsp.get_client_by_id(ctx.client_id).offset_encoding

    if #flattened_results == 0 then
      return
    elseif #flattened_results == 1 and options.jump_type ~= "never" then
      local uri = params.textDocument.uri
      if uri ~= flattened_results[1].targetUri then
        if options.jump_type == "tab" then
          vim.cmd.tabedit()
        elseif options.jump_type == "split" then
          vim.cmd.new()
        elseif options.jump_type == "vsplit" then
          vim.cmd.vnew()
        elseif options.jump_type == "tab drop" then
          local file_uri = flattened_results[1].targetUri
          if file_uri == nil then file_uri = flattened_results[1].targetUri end
          local file_path = vim.uri_to_fname(file_uri)
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

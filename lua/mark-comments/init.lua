local M = {}

local Utils = require("mark-comments.utils")
-- TODO cache

---@type number
M._augroup = nil

---@type boolean
M.enabled = false

--- List of mark names for bufnr
---@type table<number, string[]>
local mark_names = {}

--- Return list of generated marks for the current buffer
---@param bufnr number
---@return string[]
M.get_marks = function(bufnr)
  return mark_names[bufnr]
end

--- Deletes all marks local to buffer
---@param bufnr? number
M.del_marks = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  -- vim.cmd("silent! delmarks!")

  if mark_names[bufnr] == {} then return end
  for _, m in ipairs(mark_names[bufnr]) do
    vim.api.nvim_buf_del_mark(bufnr, m)
  end
  mark_names[bufnr] = {}
end

--- Iterate lines and set marks accordingly
---@param bufnr? number
M.set_marks = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  mark_names[bufnr] = {}

  -- [debug] vim.notify(tostring(M.enabled))

  for idx, line in ipairs(lines) do
    -- for every non-empty line
    if line ~= "" then
      local start = line:find("[mM]:", 0, false)
      -- restrain from 'and' keyword leading to undefined behavior
      if start then
        -- [debug] vim.notify("found m on " .. tostring(idx))

        if Utils.is_comment(bufnr, idx - 1, start - 1) then
          -- match
          for name in line:gmatch("[mM]: *([A-z])") do
            vim.api.nvim_buf_set_mark(bufnr, name, idx, 0, {})

            Utils.insert_if_absent(mark_names[bufnr], name)
          end
        end
      end
    end
  end
end

-- TODO: check what other plugins are broken
--- Checks for set_marks
local set_buf_marks = function()
  local bufnr = vim.api.nvim_get_current_buf()
  -- guards
  if not M.enabled then return end
  -- pass only normal buffers
  if Utils.get_bt(bufnr) ~= "" then return end
  -- no support for unknown filetypes
  -- if Utils.is_special_buffer(bufnr) then return end
  if Utils.get_ft(bufnr) == "" then return end
  -- [debug] vim.notify(tostring(M.enabled))
  M.set_marks(bufnr)
end

local register_autocmd = function()
  M._augroup = vim.api.nvim_create_augroup("MarkComments", {})

  -- "BufEnter"
  vim.api.nvim_create_autocmd({ "BufWritePost", "FileType" }, {
    pattern = "*",
    group = M._augroup,
    callback = set_buf_marks,
    desc = "Write local marks for current buffer"
  })
end

local disable_plugin = function()
  pcall(vim.api.nvim_clear_autocmds, { group = M._augroup })
  pcall(vim.api.nvim_del_augroup_by_name, M._augroup)
  M.enabled = false
end

--- Register plugin autocommands, change its status to enabled
M.setup = function(opts)
  opts = opts or {}

  M.enabled = true
  register_autocmd()

  -- vim.schedule(function() set_buf_marks() end)
end

--- Remove any registered plugin autocommands, change its status to disabled
M.disable = disable_plugin

return M

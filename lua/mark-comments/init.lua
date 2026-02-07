local M = {}

local Utils = require("mark-comments.utils")
-- TODO cache

---@type number
M._augroup = nil

---@type boolean
M.enabled = false

--- Iterate lines and set marks accordingly
M.set_marks = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  for idx, line in ipairs(lines) do
    -- for every non-empty line
    if line ~= "" then
      local start = line:find("[mM]:", 0, false)
      if start and Utils.is_comment(bufnr, idx - 1, start - 1) then
        -- match
        for name in line:gmatch("[mM]: *([A-z])") do
          vim.api.nvim_buf_set_mark(bufnr, name, idx, 0, {})
        end
      end
    end
  end
end

--- Deletes all marks local to buffer
M.del_marks = function()
  vim.cmd("silent! delmarks!")
end

local register_autocmd = function()
  M._augroup = vim.api.nvim_create_augroup("MarkComments", {})

  local callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    -- guards
    if not M.enabled then return end
    -- pass only normal buffers
    if Utils.get_bt(bufnr) ~= "" then return end
    -- no support for unknown filetypes
    if Utils.get_ft(bufnr) == "" then return end

    -- TODO: check what other plugins are broken
    -- if Utils.is_special_buffer(bufnr) then return end
    M.set_marks(bufnr)
  end

  vim.api.nvim_create_autocmd("BufEnter", {
    group = M._augroup,
    callback = callback,
    desc = "Write local marks when entering the buffer"
  })
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = M._augroup,
    callback = callback,
    desc = "Write local marks after writing the buffer"
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
end

--- Remove any registered plugin autocommands, change its status to disabled
M.disable = disable_plugin

return M

local M = {}

local Utils = require("mark-comments.utils")
-- TODO cache

---@type number
M._augroup = nil

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
  -- should it use BufNew? it runs just once
  M._augroup = vim.api.nvim_create_augroup("MarkComments", {})

  local callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    -- empty/normal buffer
    if not Utils.is_empty_buftype(bufnr) then return end
    if Utils.is_special_buffer(bufnr) then return end

    M.set_marks(bufnr)
  end

  vim.api.nvim_create_autocmd("BufWinEnter", {
    group = M._augroup, callback = callback
  })

  vim.api.nvim_create_autocmd("BufWritePost", {
    group = M._augroup, callback = callback
  })
end

local disable_plugin = function()
  pcall(vim.api.nvim_clear_autocmds, { group = M._augroup })
  pcall(vim.api.nvim_del_augroup_by_name, M._augroup)
end


M.setup = function(opts)
  register_autocmd()
end

M.disable = disable_plugin

return M

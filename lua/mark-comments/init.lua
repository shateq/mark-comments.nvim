local M = {}

local Utils = require("mark-comments.utils")

---@type number
M._augroup = nil

-- should it use BufNew? it runs just once
local register_autocmd = function()
  M._augroup = vim.api.nvim_create_augroup("MarkComments", {})

  vim.api.nvim_create_autocmd("BufWinEnter", {
    group = M._augroup,
    callback = function()
      local bufnr = vim.api.nvim_get_current_buf()
      -- local ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
      if Utils.is_special_buffer(bufnr) then return end

      M.set_marks(bufnr)
    end,
  })
end

local disable_plugin = function()
  pcall(vim.api.nvim_clear_autocmds, { group = M._augroup })
  pcall(vim.api.nvim_del_augroup_by_name, M._augroup)
end


-- TODO cache
M.set_marks = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  for idx, line in ipairs(lines) do
    -- print(string.format("%d: %s", i, line))

    -- TODO: check properly if it is comment
    if line:match('^//') then
      for name in line:gmatch("[mM]: *([A-z])") do
        vim.api.nvim_buf_set_mark(bufnr, name, idx, 0, {})
      end
    end
  end
end

--- Deletes all marks local to passed buffer
M.del_marks = function()
  -- bufnr = bufnr or vim.api.nvim_get_current_buf()
  vim.cmd("silent! delmarks!")
end

M.setup = function(opts)
  register_autocmd()
end

M.disable = disable_plugin

return M

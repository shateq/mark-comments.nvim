local M = {}

-- TODO: not only oil and telescope are affected
local function is_special_buffer(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })

  -- [debug]
  -- if ft == "" then print("ft empty") end
  -- print(filetype)

  if filetype == "TelescopePrompt" then
    return true
  else
    if filetype == "oil" then
      return true
    end

    return false
    -- local bufname = vim.api.nvim_buf_get_name(bufnr)
    -- return bufname:match('^oil://') ~= nil
  end
end

local register_autocmd = function()
  local group = vim.api.nvim_create_augroup("MarkComment", {})
  -- should it use BufNew? it runs just once
  vim.api.nvim_create_autocmd("BufWinEnter", {
    group = group,
    callback = function()
      local bufnr = vim.api.nvim_get_current_buf()
      -- local ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
      if is_special_buffer(bufnr) then return end

      M.set_marks(bufnr)
    end,
  })
end

local disable_plugin = function()
  pcall(vim.api.nvim_clear_autocmds, { group = "MarkComment" })
  pcall(vim.api.nvim_del_augroup_by_name, "MarkComment")
end

M.set_marks = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  -- TODO cache
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

-- Deletes all marks local to passed buffer
M.del_marks = function()
  -- bufnr = bufnr or vim.api.nvim_get_current_buf()
  vim.cmd("silent! delmarks!")
end

-- Check if treesitter is available
-- local has_treesitter, treesitter = pcall(require, "vim.treesitter")
-- if vim.treesitter.highlighter.active[bufnr] then
--   local captures = vim.treesitter.get_captures_at_pos(bufnr, i, 0)
--
--   for _, c in ipairs(captures) do
--     print(c.capture)
--   end
-- end

M.setup = function(opts)
  register_autocmd()
end

M.disable = disable_plugin

return M

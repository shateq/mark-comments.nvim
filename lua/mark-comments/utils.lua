local M = {}

-- Check if treesitter is available
-- local has_treesitter, treesitter = pcall(require, "vim.treesitter")
-- if not has_treesitter then
--   error("This plugins requires nvim-treesitter/nvim-treesitter")
-- end
-- if vim.treesitter.highlighter.active[bufnr] then
--   local captures = vim.treesitter.get_captures_at_pos(bufnr, i, 0)
--
--   for _, c in ipairs(captures) do
--     print(c.capture)
--   end
-- end

-- TODO: not only oil and telescope are affected
---@param bufnr number
---@return boolean
function M.is_special_buffer(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local filetype = vim.api.nvim_get_option_value(
    "filetype", { buf = bufnr }
  )

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

return M

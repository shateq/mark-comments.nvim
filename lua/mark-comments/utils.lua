local M = {}

---Return buffer's filetype
---@param bufnr number
---@return string
function M.get_ft(bufnr)
  -- local ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
  local ft = vim.bo[bufnr].filetype
  return ft
end

---Return buffer's type
---@param bufnr number
---@return string
function M.get_bt(bufnr)
  -- local bt = vim.api.nvim_get_option_value("buftype", { buf = bufnr })
  local bt = vim.bo[bufnr].buftype
  return bt
end

--- Returns true if treesitter captures comment on passed position
---@param bufnr number
---@param row number
---@param col number
---@return boolean
function M.is_comment(bufnr, row, col)
  if vim.treesitter.highlighter.active[bufnr] then
    -- row: 0 indexed col: 0 indexed
    local capts = vim.treesitter.get_captures_at_pos(bufnr, row, col)

    for _, c in ipairs(capts) do
      if c.capture == "comment" then
        return true
      end
    end
  end

  return false
  -- TODO should we add fallback for no tresitter highlighter?
  -- if vim.treesitter isn't available its probably nvim 0.5
end

--- Insert if not exists
---@param tbl table
---@param value any
function M.insert_if_absent(tbl, value)
  for _, v in ipairs(tbl) do
    if v == value then return end
  end
  table.insert(tbl, value)
end

--- Returns true if buffer isn't a 'working' buffer,
--- that is a normal buffer for editing not provided by a plugin
---@param bufnr number
---@return boolean
function M.is_special_buffer(bufnr)
  local filetype = vim.api.nvim_get_option_value(
    "filetype", { buf = bufnr }
  )
  -- [debug]
  -- if ft == "" then print("ft empty") end
  -- print(filetype)
  local p = filetype == "TelescopePrompt"
  local r = filetype == "TelescopeResults"
  local o = filetype == "oil"

  return p or r or o
  -- TODO: not only oil and telescope are affected
  -- vim.api.nvim_buf_get_name(bufnr):match('^oil://') ~= nil
end

--- Checks if treesitter recognizes buffer bufnr language
---@param bufnr number
---@return boolean
local function is_treesitter_lang(bufnr)
  -- it logs oil filetype btw

  local ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
  local lang = vim.treesitter.language.get_lang(ft)
  return lang ~= ""
end

return M

local M = {}

--- Return if buftype is empty which means normal buffer
---@param bufnr number
---@return boolean
function M.is_empty_buftype(bufnr)
  local bt = vim.api.nvim_get_option_value("buftype", { buf = bufnr })

  return bt == ""
end

---@param bufnr number
---@param row number
---@param col number
---@return boolean
function M.is_comment(bufnr, row, col)
  -- TODO should we add fallback for no tresitter highlighter?
  -- if vim.treesitter isn't available its probably nvim 0.5
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
end

-- TODO: not only oil and telescope are affected
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
  -- vim.api.nvim_buf_get_name(bufnr):match('^oil://') ~= nil
end

---@param bufnr number
---@return boolean
local function is_treesitter_lang(bufnr)
  -- it logs oil filetype btw

  local ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
  local lang = vim.treesitter.language.get_lang(ft)
  return lang ~= ""
end

return M

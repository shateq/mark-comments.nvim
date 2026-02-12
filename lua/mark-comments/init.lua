local M = {}

local Utils = require("mark-comments.utils")

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

  if mark_names[bufnr] == nil then return end
  for _, m in ipairs(mark_names[bufnr]) do
    vim.api.nvim_buf_del_mark(bufnr, m)
  end
  mark_names[bufnr] = nil
end

--- Iterate lines and set marks accordingly
---@param bufnr? number
M.set_marks = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  -- if mark_names[bufnr] == nil then
  mark_names[bufnr] = {}
  -- end

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

--- Automatically mark headers, feature
---@param bufnr? number
M.set_header_marks = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  if mark_names[bufnr] == nil then
    mark_names[bufnr] = {}
  end

  -- %p - punctuation marks also capture funtctions
  -- GOAL IS id like //2  (comment with just number to be considered header)
  -- how to check if comment empty
  local header_def = "%d+%.%d? +"
  -- it doesnt remove old fucks from before write
  -- idea, do custom autocmd only for write where it also refreshes

  -- TODO get rid of goto
  for idx, line in ipairs(lines) do
    if line == "" then goto continue end
    local start = line:find(header_def, 0, false)

    if not start then goto continue end
    --
    if not Utils.is_comment(bufnr, idx - 1, start - 1) then goto continue end
    --
    local name = Utils.next_free_mark(bufnr)
    vim.notify("header on " .. tostring(idx))

    -- m.pos -> [bufnum, lnum, col, off]
    local occupied_rows = vim.iter(vim.fn.getmarklist(bufnr))
        :filter(function(m)
          return m.mark:match("%l", 2)
        end)
        :map(function(m)
          return m.pos[2]
        end)
        :totable()

    if not vim.tbl_contains(occupied_rows, idx) then
      vim.notify("row " .. tostring(idx))

      vim.api.nvim_buf_set_mark(bufnr, name, idx, 0, {})
      Utils.insert_if_absent(mark_names[bufnr], name)
    end

    ::continue::
  end

  Utils.refresh_gutter()
end

--- Assign autocmd group and register required autocommands
local register_autocmd = function()
  M._augroup = vim.api.nvim_create_augroup("MarkComments", {})

  --M:a, "FileType"
  -- BufWinEnter ran on completion window opening
  -- BufEnter ran on clicking on the buffer window
  vim.api.nvim_create_autocmd({ "BufWritePost", "BufAdd", "BufReadPost" }, {
    pattern = "*",
    group = M._augroup,
    callback = vim.schedule_wrap(function()
      -- M.set_header_marks()
      set_buf_marks()
    end),
    desc = "Write local marks for current buffer"
  })

  vim.api.nvim_create_autocmd("BufDelete", {
    pattern = "*",
    group = M._augroup,
    callback = function(ev)
      mark_names[ev.buf] = nil
    end,
    desc = "Remove cached marks for deleted buffer",
  })
end

--- Remove namespace registered autocommands
local remove_autocmd = function()
  pcall(vim.api.nvim_clear_autocmds, { group = M._augroup })
  pcall(vim.api.nvim_del_augroup_by_name, M._augroup)
end

--- Register plugin autocommands, change its status to enabled
M.setup = function(opts)
  opts = opts or {}

  M.enabled = true
  register_autocmd()

  -- vim.schedule(function() set_buf_marks() end)
end

--- Remove any registered plugin autocommands, change its status to disabled
M.disable = function()
  M.enabled = false
  remove_autocmd()
end

return M

-- M:a
-- Telescope extension allowing to browse through created marks, aka chapters of the file
local has_telescope, telescope = pcall(require, "telescope")

if not has_telescope then
  error("This mark-comments.nvim integration requires nvim-telescope/telescope.nvim")
end

local Pickers = require "telescope.pickers"
local Finders = require "telescope.finders"
local Conf = require "telescope.config".values

local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

-- local marks (M:b)
local marked = function(opts)
  opts = opts or {}
  local bufnr = vim.api.nvim_get_current_buf()
  local marks = vim.fn.getmarklist(bufnr)

  if #marks < 1 then
    vim.notify("No marks to search through", 3)
    return
  end

  local results = {}
  for _, m in ipairs(marks) do
    table.insert(results, { m.mark:sub(2), m.pos })
  end


  Pickers.new(opts, {
    prompt_title = "Mark prompt",
    results_title = "Markers",
    finder = Finders.new_table {
      results = results,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry[1],
          ordinal = entry[1],
        }
      end
    },
    sorter = Conf.generic_sorter(opts),
    -- previewer = Conf.grep_previewer(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()

        vim.cmd("'" .. selection.value[1])
        -- Could also use vim.api.nvim_win_set_cursor()
      end)
      return true
    end,
  }):find()
end

-- m:c
marked(
  require("telescope.themes").get_dropdown {}
)

-- require('telescope').load_extension('fzy_native')
return telescope.register_extension({ exports = { ["mark-comments"] = marked, marked = marked } })

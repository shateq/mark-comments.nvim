-- Telescope extension allowing to browse through created marks, aka chapters of the file
-- goto on onter
-- luafile %
local has_telescope, telescope = pcall(require, "telescope")

if not has_telescope then
  error("Mark comments integration requires nvim-telescope/telescope.nvim")
end

local Pickers = require "telescope.pickers"
local make_entry = require "telescope.make_entry"
local finders = require "telescope.finders"
local Conf = require "telescope.config".values

local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

-- local marks
local marked = function(opts)
  opts = opts or {}
  Pickers.new(opts, {
    prompt_title = "Markers",
    finder = finders.new_table {
      results = { "a", "b", "c" }
    },
    sorter = Conf.generic_sorter(opts),
  }):find()
end

marked(
  require("telescope.themes").get_dropdown {}
)

-- require('telescope').load_extension('fzy_native')

-- return telescope.register_extension({ exports = { ["mark-comments"] = marks, todo = marks } })

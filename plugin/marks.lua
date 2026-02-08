vim.api.nvim_create_user_command("MarkComments", function()
  -- Easy Reloading
  package.loaded["mark-comments"] = nil
  require("mark-comments").setup()
end, {})

vim.api.nvim_create_user_command("MarkCommentsReset", function()
  local mark = require("mark-comments")

  mark.del_marks()
  mark.set_marks() --are guard needed here?
  require("mark-comments.utils").refresh_gutter()
end, {})

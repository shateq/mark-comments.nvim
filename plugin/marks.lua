vim.api.nvim_create_user_command("MarkComments", function()
  -- Easy Reloading
  package.loaded["mark-comments"] = nil
  require("mark-comments").setup()
end, {})

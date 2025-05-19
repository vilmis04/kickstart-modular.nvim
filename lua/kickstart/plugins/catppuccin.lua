-- catppuccin

return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000, -- Make sure to load this before all the other start plugins.
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    -- require('catppuccin').setup {
    --   styles = {
    --     comments = { italic = false }, -- Disable italics in comments
    --   },
    -- }

    -- Load the colorscheme here.
    vim.cmd.colorscheme 'catppuccin-frappe'
  end,
}

-- vim: ts=2 sts=2 sw=2 et

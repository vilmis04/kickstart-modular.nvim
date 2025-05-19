-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
    { '<leader><leader>', ':Neotree float buffers<CR>', desc = 'NeoTree open buffer list', silent = true },
    { '<leader>gs', ':Neotree float git_status<CR>', desc = 'NeoTree open [g]it [s]tatus', silent = true },
  },
  opts = {
    filesystem = {
      components = {
        icon = function(config, node, state)
          local highlights = require 'neo-tree.ui.highlights'
          local icon = config.default or ' '
          local padding = config.padding or ' '
          local highlight = config.highlight or highlights.FILE_ICON

          if node.type == 'directory' then
            highlight = highlights.DIRECTORY_ICON
            if node:is_expanded() then
              icon = config.folder_open or '-'
            else
              icon = config.folder_closed or '+'
            end
          elseif node.type == 'file' then
            local success, web_devicons = pcall(require, 'nvim-web-devicons')
            if success then
              local devicon, hl = web_devicons.get_icon(node.name, node.ext)
              icon = devicon or icon
              highlight = hl or highlight
            end
          end

          return {
            text = icon .. padding,
            highlight = highlight,
          }
        end,
      },
      filtered_items = {
        visible = true,
      },
      window = {
        position = 'float',
        mappings = {
          ['\\'] = 'close_window',
          ['e'] = function()
            vim.api.nvim_exec2('Neotree focus filesystem float', { output = true })
          end,
          ['b'] = function()
            vim.api.nvim_exec2('Neotree focus buffers float', { output = true })
          end,
        },
      },
    },
  },
}

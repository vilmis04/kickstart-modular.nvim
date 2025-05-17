-- Prettier

return {
  'prettier/vim-prettier',
  build = 'npm install',
  ft = { 'javascript', 'typescript', 'css', 'less', 'scss', 'graphql', 'markdown', 'vue', 'html' },
}, {
  'sindrets/diffview.nvim',
}, {
  'brenton-leighton/multiple-cursors.nvim',
  version = '*', -- Use the latest tagged version
  opts = {}, -- This causes the plugin setup function to be called
  keys = {
    { '<A-J>', '<Cmd>MultipleCursorsAddDown<CR>', mode = { 'n', 'x' }, desc = 'Add cursor and move down' },
    { '<A-K>', '<Cmd>MultipleCursorsAddUp<CR>', mode = { 'n', 'x' }, desc = 'Add cursor and move up' },

    --
    { '<A-a>', '<Cmd>MultipleCursorsAddMatches<CR>', mode = { 'n', 'x' }, desc = 'Add cursors to all cword' },
    {
      '<A-d>',
      '<Cmd>MultipleCursorsAddJumpNextMatch<CR>',
      mode = { 'n', 'x' },
      desc = 'Add cursor and jump to next cword',
    },
    { '<C-A-d>', '<Cmd>MultipleCursorsJumpNextMatch<CR>', mode = { 'n', 'x' }, desc = 'Jump to next cword' },
  },
}

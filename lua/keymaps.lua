-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
vim.keymap.set('n', '<C-D>', ':e ++ff=dos<CR>', { desc = 'Switch fileformat to [d]os' })

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open diagnostic [E]rror message context menu' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<leader>h', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<leader>l', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<leader>j', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<leader>k', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

function ToggleOrCreateTerminal()
  local term_buf = nil
  -- Iterate over all listed buffers
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    -- Check if the buffer is loaded and if it's a terminal buffer
    if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buftype == 'terminal' then
      term_buf = bufnr
      break
    end
  end

  if term_buf then
    -- If a terminal buffer exists, switch to it
    vim.api.nvim_set_current_buf(term_buf)
  else
    vim.cmd 'term'
    -- You could also use :term, :vnew | term, :tabnew | term etc.
    -- For example, to open in a vertical split:
    -- vim.cmd('vnew | terminal')
    -- To open in a new tab:
    -- vim.cmd('tabnew | terminal')
  end
end

-- Map the function to <C-`>
vim.keymap.set('n', '<leader>0', ToggleOrCreateTerminal, { noremap = true, silent = true, desc = 'Toggle/Open Terminal' })

-- open terminal
vim.keymap.set('n', '<leader>ts', ':split | resize 15 | terminal<CR>', { desc = 'Open [T]erminal in horizontally [S]plit window' })
vim.keymap.set('n', '<leader>tv', ':vsplit | vertical resize 80 | terminal<CR>', { desc = 'Open [T]erminal in [V]ertically split window' })
vim.keymap.set('n', '<leader>to', ':terminal<CR>', { desc = '[O]pen [T]erminal in current window' })

-- window management
vim.keymap.set('n', '<leader>ws', ':split<CR>', { desc = 'Open [W]indow in horizontal [S]plit' })
vim.keymap.set('n', '<leader>wv', ':vsplit<CR>', { desc = 'Open [W]indow in [V]ertical split' })

-- save on ctrl+s
vim.keymap.set('n', '<C-s>', '<Esc><cmd>w<CR>', { desc = 'Switch to normal mode and save' })
vim.keymap.set('i', '<C-s>', '<Esc><cmd>w<CR>', { desc = 'Switch to normal mode and save' })

-- next / prev buffer
vim.keymap.set('n', '<C-b>n', ':bnext<CR>', { desc = 'Switch to next file in buffer' })
vim.keymap.set('n', '<C-b>p', ':bprev<CR>', { desc = 'Switch to previous file in buffer' })

-- show project tree
vim.keymap.set('n', '-', vim.cmd.Ex, { desc = 'Show project view / tree' })

-- format files
-- json:
vim.keymap.set('n', '<leader>cfj', ':%!jq .<CR>', { desc = 'Run [C]ode [F]ormatting for [J]SON file' })

-- vim: ts=2 sts=2 sw=2 et

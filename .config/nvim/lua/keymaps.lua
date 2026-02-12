vim.keymap.set('n', '<Leader><Leader>', ':w<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>q', ':q<CR>', { noremap = true, silent = true })
vim.keymap.set('n', 'J', 'mzJ`z', { noremap = true, silent = true })
vim.keymap.set('n', '<C-h>', 'gT', { noremap = true, silent = true })
vim.keymap.set('n', '<C-l>', 'gt', { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>ra', ':%s//g<Left><Left>', { noremap = true, silent = false })
vim.keymap.set('n', '<Leader>rs', ':s//g<Left><Left>', { noremap = true, silent = false })
vim.keymap.set('n', '<Leader>rws', ':s/<c-r>=expand("<cword>")<CR>//g<Left><Left>', { noremap = true, silent = false })
vim.keymap.set('n', '<Leader>rwa', ':%s/<c-r>=expand("<cword>")<CR>//g<Left><Left>', { noremap = true, silent = false })

vim.keymap.set('n', '<Leader>gg', ':terminal lazygit<CR>i', { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>tc', '', {
  noremap = true,
  silent = true,
  callback = function()
    vim.o.cursorcolumn = not vim.o.cursorcolumn
    require('ibl').setup_buffer(0, { enabled = vim.o.cursorcolumn })
  end,
  desc = 'toggle cursor pos and scope highlighting',
})

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
vim.keymap.set('v', '<Leader>ra', ':s//g<Left><Left>', { noremap = true, silent = false })

vim.keymap.set('x', '<Leader>p', '"_dP')

vim.keymap.set('i', ';a', '[]<ESC>i', { noremap = true, silent = true })
vim.keymap.set('i', ';f', '()<ESC>i', { noremap = true, silent = true })
vim.keymap.set('i', ';v', '{}<ESC>i', { noremap = true, silent = true })
vim.keymap.set('i', ';t', '<><ESC>i', { noremap = true, silent = true })
vim.keymap.set('i', ';s', "''<ESC>i", { noremap = true, silent = true })
vim.keymap.set('i', ';d', '""<ESC>i', { noremap = true, silent = true })

local function smart_enter()
  local _, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()
  local char = line:sub(col + 1, col + 1)
  local prev_char = line:sub(col, col)

  local bracket_pairs = {
    [']'] = '[',
    ['}'] = '{',
    -- [')'] = '(',
  }

  -- Check if we're inside a string (line contains a quote character)
  local function count_quotes(str, pos)
    local count = 0
    for i = 1, pos do
      if str:sub(i, i) == '"' then
        -- Check if the quote is escaped
        if i > 1 and str:sub(i - 1, i - 1) == '\\' then
          -- Skip escaped quotes
        else
          count = count + 1
        end
      end
    end
    return count
  end

  local inside_string = count_quotes(line, col) % 2 == 1

  local is_empty_bracket = bracket_pairs[char] and prev_char == bracket_pairs[char]
  local skip_chars = { ['"'] = true, ["'"] = true, ['`'] = true, [')'] = true, [']'] = true, ['}'] = true, ['>'] = true }

  if char == '}' and inside_string then
    return vim.api.nvim_replace_termcodes('<Right>', true, false, false)
  elseif skip_chars[char] and not is_empty_bracket then
    return vim.api.nvim_replace_termcodes('<Right>', true, false, false)
  else
    if is_empty_bracket then
      return vim.api.nvim_replace_termcodes('<CR><ESC>O', true, false, true)
    else
      return vim.api.nvim_replace_termcodes('<CR>', true, false, true)
    end
  end
end

vim.keymap.set('i', '<CR>', smart_enter, { expr = true, noremap = true })

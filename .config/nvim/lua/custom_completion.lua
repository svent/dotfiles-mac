-- Dynamic fallback completion:
-- In buffers without an attached LSP client, make <Tab> behave like:
--   1) open built-in keyword completion (<C-x><C-p>)
--   2) if popup menu is visible, accept current item (<C-y>)
-- In buffers with LSP (and blink.cmp), remove this local override so blink keeps control.

local group = vim.api.nvim_create_augroup('DynamicFallbackCompletion', { clear = true })

-- Track only maps created by this module so we never delete mappings owned by
-- other plugins (e.g. blink.cmp).
local fallback_maps_active = {}

local function should_use_fallback(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return false
  end

  -- Only normal editable file buffers
  if vim.bo[bufnr].buftype ~= '' or not vim.bo[bufnr].modifiable then
    return false
  end

  local clients = vim.lsp.get_clients { bufnr = bufnr }
  return #clients == 0
end

local function tab_fallback()
  -- If completion menu is already visible: accept current entry
  if vim.fn.pumvisible() == 1 then
    return '<C-y>'
  end

  local col = vim.fn.col '.' - 1
  local line = vim.fn.getline '.'

  -- Preserve normal tab/indent behavior at BOL or after whitespace
  if col <= 0 or line:sub(col, col):match '%s' then
    return '<Tab>'
  end

  -- Trigger built-in keyword completion
  return '<C-x><C-p>'
end

local function ctrl_j_fallback()
  if vim.fn.pumvisible() == 1 then
    return '<C-n>'
  end
  return '<C-j>'
end

local function ctrl_k_fallback()
  if vim.fn.pumvisible() == 1 then
    return '<C-p>'
  end
  return '<C-k>'
end

local function set_fallback_maps(bufnr)
  vim.keymap.set('i', '<Tab>', tab_fallback, {
    buffer = bufnr,
    expr = true,
    silent = true,
    desc = 'Fallback completion: trigger/accept',
  })

  vim.keymap.set('i', '<C-Space>', '<C-x><C-p>', {
    buffer = bufnr,
    desc = 'Fallback completion: trigger',
  })

  vim.keymap.set('i', '<C-j>', ctrl_j_fallback, {
    buffer = bufnr,
    expr = true,
    silent = true,
    desc = 'Fallback completion: next item',
  })

  vim.keymap.set('i', '<C-k>', ctrl_k_fallback, {
    buffer = bufnr,
    expr = true,
    silent = true,
    desc = 'Fallback completion: previous item',
  })

  fallback_maps_active[bufnr] = true
end

local function clear_fallback_maps(bufnr)
  if not fallback_maps_active[bufnr] then
    return
  end

  pcall(vim.keymap.del, 'i', '<Tab>', { buffer = bufnr })
  pcall(vim.keymap.del, 'i', '<C-Space>', { buffer = bufnr })
  pcall(vim.keymap.del, 'i', '<C-j>', { buffer = bufnr })
  pcall(vim.keymap.del, 'i', '<C-k>', { buffer = bufnr })

  fallback_maps_active[bufnr] = nil
end

local function refresh_buffer_maps(bufnr)
  if should_use_fallback(bufnr) then
    if not fallback_maps_active[bufnr] then
      set_fallback_maps(bufnr)
    end
  else
    clear_fallback_maps(bufnr)
  end
end

vim.api.nvim_create_autocmd({ 'BufEnter', 'FileType' }, {
  group = group,
  callback = function(args)
    refresh_buffer_maps(args.buf)
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = group,
  callback = function(args)
    -- Delay to the next loop tick so completion plugins that react to LspAttach
    -- can install their own mappings first.
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(args.buf) then
        refresh_buffer_maps(args.buf)
      end
    end)
  end,
})

vim.api.nvim_create_autocmd('LspDetach', {
  group = group,
  callback = function(args)
    refresh_buffer_maps(args.buf)
  end,
})

vim.api.nvim_create_autocmd('BufWipeout', {
  group = group,
  callback = function(args)
    fallback_maps_active[args.buf] = nil
  end,
})

return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  event = 'VeryLazy',
  keys = {
    {
      ';',
      function()
        local ts_repeat_move = require 'nvim-treesitter.textobjects.repeatable_move'
        ts_repeat_move.repeat_last_move()
      end,
      mode = { 'n', 'x', 'o' },
      desc = 'Repeat last Treesitter textobject move',
    },
    {
      ',',
      function()
        local ts_repeat_move = require 'nvim-treesitter.textobjects.repeatable_move'
        ts_repeat_move.repeat_last_move_opposite()
      end,
      mode = { 'n', 'x', 'o' },
      desc = 'Repeat last Treesitter textobject move',
    },
  },
  config = function()
    require('nvim-treesitter.configs').setup {
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['if'] = '@function.inner',
            ['af'] = '@function.outer',
            ['ic'] = '@call.inner',
            ['ac'] = '@call.outer',
            ['ia'] = '@assignment.rhs',
          },
        },
        move = {
          enable = true,
          goto_next_start = {
            [']f'] = '@function.outer',
          },
          goto_next_end = {
            [']F'] = '@function.outer',
          },
          goto_previous_start = {
            ['[f'] = '@function.outer',
          },
          goto_previous_end = {
            ['[F'] = '@function.outer',
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ['<leader>aa'] = '@parameter.inner',
          },
          swap_previous = {
            ['<leader>aA'] = '@parameter.inner',
          },
        },
      },
    }
  end,
}

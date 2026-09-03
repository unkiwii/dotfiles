-- Strikethrough toggles. `-` and `_` shadow their "first non-blank" motions
-- here, which is a fine trade in prose.
--   -iw / -ap / -2j   toggle over a motion or text object (repeats with `.`)
--   --                toggle the current line
--   _                 toggle from the cursor to the end of the line
--   -                 toggle the selection, in visual/visual-line mode
local strike = require('strikethrough')

vim.keymap.set('x', '-', strike.visual,
  { buffer = true, desc = 'Toggle ~~strikethrough~~ on selection' })

local function operator(motion)
  return function()
    vim.o.operatorfunc = "v:lua.require'strikethrough'.opfunc"
    return 'g@' .. motion
  end
end

vim.keymap.set('n', '-', operator(''),
  { buffer = true, expr = true, desc = 'Toggle ~~strikethrough~~ (operator)' })
vim.keymap.set('n', '--', operator('_'),
  { buffer = true, expr = true, desc = 'Toggle ~~strikethrough~~ on line' })
vim.keymap.set('n', '_', operator('$'),
  { buffer = true, expr = true, desc = 'Toggle ~~strikethrough~~ to end of line' })

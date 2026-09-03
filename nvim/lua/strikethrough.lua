-- Toggle GFM ~~strikethrough~~ over a range as a single undoable edit.
-- Multi-line ranges are struck per line, since strikethrough does not span
-- markdown block boundaries.

local M = {}

local STRIKE = '~~'

-- Start of the real content, past any list/quote/heading marker, so that
-- `- [ ] task` strikes the task and leaves the checkbox alone.
local function content_start(line)
  local pos = #line:match('^%s*')
  local rest = line:sub(pos + 1)
  local marker = rest:match('^[-*+]%s+') or rest:match('^%d+[.)]%s+')
    or rest:match('^>%s+') or rest:match('^#+%s+')
  if marker then
    pos = pos + #marker
    local box = line:sub(pos + 1):match('^%[.%]%s+')
    if box then pos = pos + #box end
  end
  return pos
end

-- Narrow [s,e) to its non-blank content; nil when the span is blank.
local function trim(line, s, e)
  local seg = line:sub(s + 1, e)
  s = s + #seg:match('^%s*')
  e = e - #seg:match('%s*$')
  if s >= e then return nil end
  return s, e
end

-- Start columns of each ~~ .. ~~ pair on the line, as {open, close} (0-based).
local function marker_pairs(line)
  local out, open, i = {}, nil, 1
  while true do
    local at = line:find(STRIKE, i, true)
    if not at then return out end
    if open then
      table.insert(out, { open - 1, at - 1 })
      open = nil
    else
      open = at
    end
    i = at + 2
  end
end

-- Whether [s,e) is already struck, and which region to unstrike:
--   'region' — it sits inside a ~~ .. ~~ pair (markers inside, hugging, or
--              enclosing it), so unstriking means dropping that pair
--   'strip'  — it straddles markers, so unstriking means removing them all
local function struck(line, s, e)
  for _, p in ipairs(marker_pairs(line)) do
    if p[1] <= s and e <= p[2] + 2 then
      return 'region', p[1], p[2] + 2
    end
  end
  if line:sub(s + 1, e):find(STRIKE, 1, true) then
    return 'strip', s, e
  end
  return nil
end

-- Columns line `i` of `lines` covers, per motion kind.
local function span(kind, lines, i, scol, ecol)
  local line = lines[i]
  if kind == 'line' then
    return content_start(line), #line
  elseif kind == 'block' then
    return math.min(scol, #line), math.min(ecol, #line)
  end
  local s = (i == 1) and scol or 0
  local e = (i == #lines) and math.min(ecol, #line) or #line
  return s, e
end

local function toggle(kind, srow, scol, erow, ecol)
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, srow, erow + 1, false)

  local targets = {}
  for i, line in ipairs(lines) do
    local s, e = trim(line, span(kind, lines, i, scol, ecol))
    if s then
      local how, hs, he = struck(line, s, e)
      table.insert(targets, { i = i, s = hs or s, e = he or e, how = how })
    end
  end
  if #targets == 0 then return end

  -- Unstrike only when every target is already struck; otherwise strike the
  -- ones that aren't.
  local all_struck = true
  for _, t in ipairs(targets) do
    if not t.how then
      all_struck = false
      break
    end
  end

  for _, t in ipairs(targets) do
    local line = lines[t.i]
    if all_struck then
      if t.how == 'region' then
        lines[t.i] = line:sub(1, t.s) .. line:sub(t.s + 3, t.e - 2) .. line:sub(t.e + 1)
      else
        lines[t.i] = line:sub(1, t.s) .. (line:sub(t.s + 1, t.e):gsub(STRIKE, '')) .. line:sub(t.e + 1)
      end
    elseif not t.how then
      lines[t.i] = line:sub(1, t.s) .. STRIKE .. line:sub(t.s + 1, t.e) .. STRIKE .. line:sub(t.e + 1)
    end
  end

  -- One set_lines call for the whole range keeps this to a single undo step.
  vim.api.nvim_buf_set_lines(buf, srow, erow + 1, false, lines)
end

-- 'operatorfunc' target, so `-iw` / `-ap` / `-2j` work and repeat with `.`
function M.opfunc(motion)
  local a = vim.api.nvim_buf_get_mark(0, '[')
  local b = vim.api.nvim_buf_get_mark(0, ']')
  local kind = (motion == 'line' and 'line') or (motion == 'block' and 'block') or 'char'
  toggle(kind, a[1] - 1, a[2], b[1] - 1, b[2] + 1)
end

function M.visual()
  local mode = vim.fn.mode()
  local a, b = vim.fn.getpos('v'), vim.fn.getpos('.')
  if a[2] > b[2] or (a[2] == b[2] and a[3] > b[3]) then a, b = b, a end
  local kind = (mode == 'V' and 'line') or (mode == '\22' and 'block') or 'char'
  local scol, ecol = a[3] - 1, b[3]
  if kind == 'block' then
    scol, ecol = math.min(a[3], b[3]) - 1, math.max(a[3], b[3])
  end
  toggle(kind, a[2] - 1, scol, b[2] - 1, ecol)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<esc>', true, false, true), 'n', false)
end

return M

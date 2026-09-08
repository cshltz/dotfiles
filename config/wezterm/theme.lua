local THEMES = { 'dusk', 'day', 'darkness' }

local M = {}

M.THEMES = THEMES

M.default_theme = os.getenv 'WEZTERM_THEME' or 'dusk'

function M.load(name)
  local ok, palette = pcall(require, 'palettes.' .. name)
  if not ok then
    return require 'palettes.dusk'
  end
  return palette
end

function M.copy(name)
  local copy = {}
  for key, value in pairs(M.load(name)) do
    copy[key] = value
  end
  return copy
end

local current_index

local function index_for(name)
  for i = 1, #THEMES do
    if THEMES[i] == name then
      return i
    end
  end
  return 1
end

function M.next_name()
  if not current_index then
    current_index = index_for(M.default_theme)
  end
  current_index = current_index % #THEMES + 1
  return THEMES[current_index]
end

return M

-- https://www.reddit.com/r/wezterm/comments/1bbq6ro/i_implemented_a_theme_switcher/
local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

-- https://github.com/wez/wezterm/issues/4429
wezterm.on('toggle-colorscheme', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  if not overrides.color_scheme then
    -- overrides.color_scheme = "PaperColor Light (base16)"
    overrides.color_scheme = "Papercolor Light (Gogh)"
    overrides.window_background_opacity = 0.95
  else
    overrides.color_scheme = nil
    overrides.window_background_opacity = nil
  end
  window:set_config_overrides(overrides)
end)

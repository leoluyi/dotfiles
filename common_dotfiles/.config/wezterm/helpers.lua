local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

-- https://github.com/wez/wezterm/issues/4429
wezterm.on("toggle-colorscheme", function(window, pane)
  local overrides = window:get_config_overrides() or {}
  if not overrides.color_scheme then
    -- overrides.color_scheme = "PaperColor Light (base16)"
    overrides.color_scheme = "rose-pine-dawn"
    overrides.window_background_opacity = 0.97
  else
    overrides.color_scheme = nil
    overrides.window_background_opacity = nil
  end
  window:set_config_overrides(overrides)
end)

-- https://www.reddit.com/r/wezterm/comments/1bbq6ro/i_implemented_a_theme_switcher/
M.theme_switcher = function(window, pane)
  -- get builting color schemes
  local schemes = wezterm.get_builtin_color_schemes()
  local choices = {}
  local config_path = "~/.config/wezterm/wezterm.lua"

  -- populate theme names in choices list
  for key, _ in pairs(schemes) do
    table.insert(choices, { label = tostring(key) })
  end

  -- sort choices list
  table.sort(choices, function(c1, c2)
    return c1.label < c2.label
  end)

  window:perform_action(
    act.InputSelector({
      title = "🎨 Pick a Theme!",
      choices = choices,
      fuzzy = true,

      -- execute 'sed' shell command to replace the line
      -- responsible of colorscheme in my config
      action = wezterm.action_callback(function(inner_window, _, _, label)
        local overrides = inner_window:get_config_overrides() or {}
        overrides.color_scheme = label
        overrides.window_background_opacity = 0.90
        inner_window:set_config_overrides(overrides)
      end),
    }),
    pane
  )
end

return M

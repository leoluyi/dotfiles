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
      action = wezterm.action_callback(function(inner_window, inner_pane, _, label)
        inner_window:perform_action(
          act.SpawnCommandInNewTab({
            args = {
              "sed",
              "-i",
              '/^Colorscheme/c\\Colorscheme = "' .. label .. '"',
              config_path,
            },
          }),
          inner_pane
        )
      end),
    }),
    pane
  )
end

return M

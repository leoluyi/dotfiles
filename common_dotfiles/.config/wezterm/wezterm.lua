-- < https://github.com/omerxx/dotfiles/blob/master/wezterm/wezterm.lua >
local wezterm = require("wezterm")
local helpers = require("helpers")

return {
  color_scheme = "Catppuccin Mocha",
  enable_tab_bar = false,
  font_size = 16.0,
  font = wezterm.font("JetBrains Mono"),
  macos_window_background_blur = 30,

  -- window_background_image = '${HOME}/Downloads/3840x1080-Wallpaper-041.jpg',
  -- window_background_image_hsb = {
  --     brightness = 0.01,
  --     hue = 1.0,
  --     saturation = 0.5,
  -- },
  -- window_background_opacity = 1.0,
  -- window_background_opacity = 0.92,
  window_background_opacity = 0.78,
  -- window_background_opacity = 0.20,
  window_decorations = "RESIZE",
  keys = {
    { key = "Enter", mods = "CMD", action = wezterm.action.ToggleFullScreen, },

    -- Disable defaults.
    -- $ wezterm show-keys --lua | grep -E '(LeftArrow|RightArrow|keys|key_tables|mode)'
	{ key = "LeftArrow", mods = "SHIFT|CTRL", action = wezterm.action.DisableDefaultAssignment },
	{ key = "LeftArrow", mods = "SHIFT|ALT|CTRL", action = wezterm.action.DisableDefaultAssignment },
	{ key = "RightArrow", mods = "SHIFT|CTRL", action = wezterm.action.DisableDefaultAssignment },
	{ key = "RightArrow", mods = "SHIFT|ALT|CTRL", action = wezterm.action.DisableDefaultAssignment },
	{ key = "UpArrow", mods = "SHIFT|CTRL", action = wezterm.action.DisableDefaultAssignment },
	{ key = "UpArrow", mods = "SHIFT|ALT|CTRL", action = wezterm.action.DisableDefaultAssignment },
	{ key = "DownArrow", mods = "SHIFT|CTRL", action = wezterm.action.DisableDefaultAssignment },
	{ key = "DownArrow", mods = "SHIFT|ALT|CTRL", action = wezterm.action.DisableDefaultAssignment },
    { key = "k", mods = "ALT", action = wezterm.action_callback(function(window, pane) helpers.theme_switcher(window, pane) end) },
  },
  mouse_bindings = {
    -- < https://github.com/wez/wezterm/issues/119#issuecomment-1206593847 >
    -- Change the default click behavior so that it only selects
    -- text and doesn't open hyperlinks
    {
      event  = { Up = { streak = 1, button = "Left" } },
      mods   = "NONE",
      action = wezterm.action.CompleteSelection("PrimarySelection"),
    },

    -- Ctrl-click will open the link under the mouse cursor
    {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = "CMD",
      action = wezterm.action.OpenLinkAtMouseCursor,
    },

    -- Disable the Ctrl-click down event to stop programs from seeing it when a URL is clicked
    -- < https://wezfurlong.org/wezterm/config/mouse.html?highlight=Ctrl-click#gotcha-on-binding-an-up-event-only >
    {
      event = { Down = { streak = 1, button = "Left" } },
      mods = "CMD",
      action = wezterm.action.Nop,
    },
  },
  window_close_confirmation = "NeverPrompt",
  skip_close_confirmation_for_processes_named = {
    'bash',
    'sh',
    'zsh',
    'fish',
    'tmux',
    'nu',
    'cmd.exe',
    'pwsh.exe',
    'powershell.exe',
  }
}

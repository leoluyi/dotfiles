-- Colorscheme.
vim.o.termguicolors = true
vim.o.background = "dark"

if os.getenv("theme") == "light" then
  vim.o.background = "light"
end

local get_if_available = require("util.colorscheme").get_if_available

-- Uncomment the colorscheme to use it. ==============================================

-- Dark themes.
-- local colorscheme = get_if_available("catppuccin")
-- local colorscheme = get_if_available("tokyonight-storm")
-- local colorscheme = get_if_available("bamboo")
-- local colorscheme = get_if_available("everforest")
-- local colorscheme = get_if_available("gruvbox")
local colorscheme = get_if_available("rose-pine")

-- Light themes.
-- local colorscheme = get_if_available("rose-pine-dawn")

-- Set the colorscheme. ==============================================================
vim.cmd.colorscheme(colorscheme)
return colorscheme

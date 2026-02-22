-- < https://github.com/nvim-lualine/lualine.nvim >

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      { "nvim-tree/nvim-web-devicons", lazy = true },
    },
    opts = function()
      local function venv()
        if vim.g.virtualenv_name then
          return vim.g.virtualenv_name
        else
          return ""
        end
      end
      local icons = require("util.icons")
      local mode_map = {
        ["n"] = "N",
        ["no"] = "O-PENDING",
        ["nov"] = "O-PENDING",
        ["noV"] = "O-PENDING",
        ["no"] = "O-PENDING",
        ["niI"] = "N",
        ["niR"] = "N",
        ["niV"] = "N",
        ["nt"] = "N",
        ["v"] = "V",
        ["vs"] = "V",
        ["V"] = "VL",
        ["Vs"] = "VL",
        [""] = "VB",
        ["s"] = "VB",
        ["s"] = "S",
        ["S"] = "SL",
        [""] = "SB",
        ["i"] = "I",
        ["ic"] = "I",
        ["ix"] = "I",
        ["R"] = "R",
        ["Rc"] = "R",
        ["Rx"] = "R",
        ["Rv"] = "VR",
        ["Rvc"] = "VR",
        ["Rvx"] = "VR",
        ["c"] = "C",
        ["cv"] = "EX",
        ["ce"] = "EX",
        ["r"] = "R",
        ["rm"] = "MORE",
        ["r?"] = "CONFIRM",
        ["!"] = "SHELL",
        ["t"] = "TERM",
      }

      return {
        options = {
          icons_enabled = true,
          theme = "auto",
          component_separators = { left = "", right = "" },
          -- section_separators = { left = '', right = ''},
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            "dashboard",
            "alpha",
          },
          always_divide_middle = true,
          globalstatus = true,
        },
        sections = {
          lualine_a = {
            function()
              local paste_mode = vim.go.paste and " (PASTE)" or ""
              return (mode_map[vim.api.nvim_get_mode().mode] .. paste_mode) or "_"
            end,
          },
          lualine_b = {
            { "branch", icon = "" },
            { "diagnostics" },
            { venv },
          },
          lualine_c = {
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
          },
          lualine_x = {
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
            },
          },
          lualine_y = {
            "encoding",
            "fileformat",
            "filetype",
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
          lualine_z = {
            {
              function()
                return " " .. os.date("%R")
              end,
            },
          },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        extensions = { "lazy" },
      }
    end,

    config = function(_, opts)
      -- Debug: Print the number of elements in opts.sections.lualine_x.
      -- print(#opts.sections.lualine_x)

      local lualine = require("lualine")
      lualine.setup(opts)
    end,
  },
}

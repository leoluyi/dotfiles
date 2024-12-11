-- References
-- https://github.com/exosyphon/nvim/blob/main/lua/plugins/obsidian.lua
-- https://github.com/agalea91/dotfiles/blob/main/nvim/lua/plugins/obsidian.lua
-- https://mcanueste.com/posts/obsidian-nvim-customizations-for-capture-notes/
-- https://www.youtube.com/watch?v=1Lmyh0YRH-w

return {
  {
    -- < https://github.com/epwalsh/obsidian.nvim >
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    keys = {
      { "<leader>o", desc = "+Obsidian" },
      { "<leader>oo", ":cd /Users/leoluyi/Dropbox/_notes-vault<cr>", desc = "Navigate to Vault" },
      -- { "<leader>os", ":ObsidianSearch<cr>", desc = "ObsidianSearch" },
      { "<leader>oa", ":ObsidianNew<cr>", desc = "ObsidianNew [A]dd note" },
      { "<leader>ot", ":ObsidianTemplate<cr>", desc = "Insert Obsidian [T]emplate" },
      { "<leader>oN", ":ObsidianTemplate general<cr>", desc = "Insert Obsidian Template (General)" },
      { "<leader>or", ":ObsidianOpen<cr>", desc = "[R]eveal in Obsidian App" },
      { "<leader>ob", ":ObsidianBacklinks<cr>", desc = "Show Obsidian[B]acklinks" },
      { "<leader>ol", ":ObsidianLinks<cr>", desc = "Show Obsidian[L]inks" },
      { "<leader>os", ":ObsidianQuickSwitch<cr>", desc = "Quick [S]witch" },

      -- search for files in full vault
      -- { "<leader>os", "<cmd>lua require('telescope.builtin').find_files({" ..
      --     "search_dirs = {'/Users/leoluyi/Dropbox/_notes-vault'}," ..
      --     "find_command = { 'fd', '--type', 'f', '--extension', 'md' }," ..
      --     -- "additional_args = function(opts) return { '--extension', 'md' } end," ..
      --     "})<cr>", desc = "Search Notes" },
      {
        "<leader>og",
        "<cmd>lua require('telescope.builtin').live_grep({"
          .. "additional_args = function(opts) return { '--glob', '*.md' } end"
          .. "search_dirs = {'/Users/leoluyi/Dropbox/_notes-vault'},"
          .. "prompt_title = '  Live Grep (Obsidian)', layout_strategy = 'vertical',"
          .. "layout_config = { height = 0.95, preview_cutoff = 1, mirror = true } })<cr>",
        desc = "[G]rep in Notes",
      },
    },

    opts = {
      workspaces = {
        {
          name = "Notes",
          path = "/Users/leoluyi/Dropbox/_notes-vault",
        },
      },

      -- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
      completion = {
        -- Set to false to disable completion.
        nvim_cmp = true,
        -- Trigger completion at 2 chars.
        min_chars = 2,
      },

      ui = {
        -- Disable some things below here because I set these manually for all Markdown files using treesitter
        checkboxes = {},
        bullets = {},
      },

      -- Optional, configure key mappings. These are the defaults. If you don't want to set any keymappings this
      -- way then set 'mappings = {}'.
      mappings = {
        -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true, desc = "[O]bsidian gf_passthrough" },
        },
        -- Toggle check-boxes.
        ["<leader>ox"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          opts = { buffer = true, desc = "[O]bsidian toggle_checkbox" },
        },
        -- -- Smart action depending on context, either follow link or toggle checkbox.
        -- ["<cr>"] = {
        --   action = function()
        --     return require("obsidian").util.smart_action()
        --   end,
        --   opts = { buffer = true, expr = true },
        -- }
      },

      notes_subdir = "inbox",
      -- Where to put new notes. Valid options are
      --  * "current_dir" - put new notes in same directory as the current buffer.
      --  * "notes_subdir" - put new notes in the default notes subdirectory.
      new_notes_location = "notes_subdir",

      -- Optional, customize how wiki links are formatted. You can set this to one of:
      --  * "use_alias_only", e.g. '[[Foo Bar]]'
      --  * "prepend_note_id", e.g. '[[foo-bar|Foo Bar]]'
      --  * "prepend_note_path", e.g. '[[foo-bar.md|Foo Bar]]'
      --  * "use_path_only", e.g. '[[foo-bar.md]]'
      -- Or you can set it to a function that takes a table of options and returns a string, like this:
      wiki_link_func = "prepend_note_path",

      note_id_func = function(title)
        -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
        -- In this case a note with the title 'My new note' will be given an ID that looks
        -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
        local suffix = ""
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          -- If title is nil, just add 4 random uppercase letters to the suffix.
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.date("%Y%m%d%H%M%S")) .. "-" .. suffix
      end,

      -- Optional, customize how note file names are generated given the ID, target directory, and title.
      ---@param spec { id: string, dir: obsidian.Path, title: string|? }
      ---@return string|obsidian.Path The full path to the new note.
      note_path_func = function(spec)
        -- This is equivalent to the default behavior.
        local path = spec.dir / tostring(spec.id)
        return path:with_suffix(".md")
      end,

      -- Optional, boolean or a function that takes a filename and returns a boolean.
      -- `true` indicates that you don't want obsidian.nvim to manage frontmatter.
      disable_frontmatter = false,

      -- Optional, alternatively you can customize the frontmatter data.
      ---@return table
      note_frontmatter_func = function(note)
        -- Add the title of the note as an alias.
        if note.title then
          note:add_alias(note.title)
        end

        local out = {
          id = note.id,
          aliases = note.aliases,
          tags = note.tags,
          urls = {},
        }

        -- `note.metadata` contains any manually added fields in the frontmatter.
        -- So here we just make sure those fields are kept in the frontmatter.
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end

        return out
      end,

      -- Optional, for templates (see below).
      templates = {
        folder = "templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        -- A map for custom variables, the key should be the variable and the value a function
        substitutions = {},
      },
    },

    config = function(_, opts)
      require("obsidian").setup(opts)
    end,
  },
}

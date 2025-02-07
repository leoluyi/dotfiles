return {
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    enabled = true,
    config = function()
      local mc = require("multicursor-nvim")

      mc.setup()

      local set = vim.keymap.set

      -- Add or skip cursor above/below the main cursor.
      set({ "n", "v" }, "<up>", function()
        mc.lineAddCursor(-1)
      end)
      set({ "n", "v" }, "<down>", function()
        mc.lineAddCursor(1)
      end)
      set({ "n", "v" }, "<leader><up>", function()
        mc.lineSkipCursor(-1)
      end)
      set({ "n", "v" }, "<leader><down>", function()
        mc.lineSkipCursor(1)
      end)

      -- Add or skip adding a new cursor by matching word/selection
      set({ "n", "v" }, "<C-n>", function()
        mc.matchAddCursor(1)
      end)
      set({ "n", "v" }, "<C-s>", function()
        mc.matchSkipCursor(1)
      end)
      set({ "n", "v" }, "<C-m>", function()
        mc.matchAddCursor(-1)
      end)
      set({ "n", "v" }, "<C-,>", function()
        mc.matchSkipCursor(-1)
      end)

      -- Add all matches in the document
      set({ "n", "v" }, "<localleader>A", mc.matchAllAddCursors, { desc = "(multicursor) add all matches" })

      -- You can also add cursors with any motion you prefer:
      -- set("n", "<right>", function()
      --     mc.addCursor("w")
      -- end)
      -- set("n", "<leader><right>", function()
      --     mc.skipCursor("w")
      -- end)

      -- Rotate the main cursor.
      set({ "n", "v" }, "<left>", mc.nextCursor)
      set({ "n", "v" }, "<right>", mc.prevCursor)

      -- Delete the main cursor.
      set({ "n", "v" }, "<localleader>x", mc.deleteCursor)

      -- Add and remove cursors with control + left click.
      -- set("n", "<c-leftmouse>", mc.handleMouse)

      -- Easy way to add and remove cursors using the main cursor.
      set({ "n", "v" }, "<c-q>", mc.toggleCursor)

      -- Clone every cursor and disable the originals.
      set({ "n", "v" }, "<leader><c-q>", mc.duplicateCursors)

      set("n", "<esc>", function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        elseif mc.hasCursors() then
          mc.clearCursors()
        else
          -- Default <esc> handler.
          -- return "<cmd>noh<cr><esc>"
        end
      end)

      -- bring back cursors if you accidentally clear them
      set("n", "<leader>gv", mc.restoreCursors, { desc = "(multicursor) restore cursors" })

      -- Align cursor columns.
      set("n", "\\a", mc.alignCursors, { desc = "(multicursor) align cursor columns" })

      -- Split visual selections by regex.
      set("v", "\\S", mc.splitCursors, { desc = "(multicursor) split by regex" })

      -- Append/insert for each line of visual selections.
      set("v", "I", mc.insertVisual)
      set("v", "A", mc.appendVisual)

      -- match new cursors within visual selections by regex.
      set("v", "M", mc.matchCursors)

      -- Rotate visual selection contents.
      set("v", "<localleader>t", function()
        mc.transposeCursors(1)
      end, { desc = "(multicursor) rotate selection contents" })
      set("v", "<localleader>T", function()
        mc.transposeCursors(-1)
      end, { desc = "(multicursor) rotate selection contents" })

      -- Jumplist support
      set({ "v", "n" }, "<c-i>", mc.jumpForward)
      set({ "v", "n" }, "<c-o>", mc.jumpBackward)

      -- Customize how cursors look.
      local hl = vim.api.nvim_set_hl
      hl(0, "MultiCursorCursor", { link = "Cursor" })
      hl(0, "MultiCursorVisual", { link = "Visual" })
      hl(0, "MultiCursorSign", { link = "SignColumn" })
      hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
      hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
      hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
    end,
  },
}

local M = {}

local MODEL = "claude-sonnet-4.6"
local SYSTEM = "Be concise. Reply in plain text, no markdown formatting unless the content is code."

-- Replace [start_line, end_line] (1-indexed, inclusive) in bufnr with the LLM
-- response to the text currently occupying those lines. Runs asynchronously.
function M.query_replace(bufnr, start_line, end_line)
  local lines = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, end_line, true)
  local text = table.concat(lines, "\n")

  if text:match("^%s*$") then
    vim.notify("llm: empty input", vim.log.levels.WARN)
    return
  end

  vim.notify("llm: querying…", vim.log.levels.INFO)

  vim.system(
    { "llm", "-m", MODEL, "--system", SYSTEM },
    { text = true, stdin = text },
    vim.schedule_wrap(function(result)
      if result.code ~= 0 then
        vim.notify("llm error: " .. (result.stderr or "non-zero exit"), vim.log.levels.ERROR)
        return
      end
      local output = (result.stdout or ""):gsub("\n$", "")
      local output_lines = vim.split(output, "\n", { plain = true })
      vim.api.nvim_buf_set_lines(bufnr, start_line - 1, end_line, true, output_lines)
      vim.notify("llm: done", vim.log.levels.INFO)
    end)
  )
end

return M

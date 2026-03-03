local M = {}

-- Replace [start_line, end_line] (1-indexed, inclusive) in bufnr with the
-- output of an external command fed the text on those lines via stdin.
-- opts.cmd  — full command table; defaults to aichat with opts.role
-- opts.role — aichat role name (only used when opts.cmd is absent)
function M.query_replace(bufnr, start_line, end_line, opts)
  opts = opts or {}
  local cmd = opts.cmd or { "aichat", "-S", "-r", opts.role or "blog" }

  local lines = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, end_line, true)
  local text = table.concat(lines, "\n")

  if text:match("^%s*$") then
    vim.notify("aichat: empty input", vim.log.levels.WARN)
    return
  end

  vim.notify("aichat: querying…", vim.log.levels.INFO)

  vim.system(
    cmd,
    { text = true, stdin = text },
    vim.schedule_wrap(function(result)
      if result.code ~= 0 then
        vim.notify("aichat error: " .. (result.stderr or "non-zero exit"), vim.log.levels.ERROR)
        return
      end
      local output = (result.stdout or ""):gsub("\n$", "")
      local output_lines = vim.split(output, "\n", { plain = true })
      vim.api.nvim_buf_set_lines(bufnr, start_line - 1, end_line, true, output_lines)
      vim.notify("aichat: done", vim.log.levels.INFO)
    end)
  )
end

-- Pipe text through aichat with an inline prompt to improve/rewrite it.
function M.query_replace_auto(bufnr, start_line, end_line)
  local lines = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, end_line, true)
  local text = table.concat(lines, "\n")

  if text:match("^%s*$") then
    vim.notify("aichat: empty input", vim.log.levels.WARN)
    return
  end

  vim.notify("aichat: improving…", vim.log.levels.INFO)

  vim.system(
    { "aichat", "-S", "--prompt", "Improve this text. Output only the result, no commentary." },
    { text = true, stdin = text },
    vim.schedule_wrap(function(result)
      if result.code ~= 0 then
        vim.notify("aichat error: " .. (result.stderr or "non-zero exit"), vim.log.levels.ERROR)
        return
      end
      local output = (result.stdout or ""):gsub("\n$", "")
      local output_lines = vim.split(output, "\n", { plain = true })
      vim.api.nvim_buf_set_lines(bufnr, start_line - 1, end_line, true, output_lines)
      vim.notify("aichat: done", vim.log.levels.INFO)
    end)
  )
end

return M

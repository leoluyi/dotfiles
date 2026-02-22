local M = {}

local MODEL = "claude-sonnet-4.6"

M.SYSTEM_BLOG = "Answer clearly and concisely in a formal blog writing style. Limit to 2-3 short paragraphs. Use markdown formatting."
M.SYSTEM_CODE = "Output only the code. No explanation, no preamble, no markdown fences, no trailing commentary."

-- Replace [start_line, end_line] (1-indexed, inclusive) in bufnr with the
-- output of an external command fed the text on those lines via stdin.
-- opts.cmd    — full command table; defaults to llm with opts.system
-- opts.system — system prompt passed to llm (only used when opts.cmd is absent)
function M.query_replace(bufnr, start_line, end_line, opts)
  opts = opts or {}
  local cmd = opts.cmd or { "llm", "-m", MODEL, "--system", opts.system or M.SYSTEM_BLOG }

  local lines = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, end_line, true)
  local text = table.concat(lines, "\n")

  if text:match("^%s*$") then
    vim.notify("llm: empty input", vim.log.levels.WARN)
    return
  end

  vim.notify("llm: querying…", vim.log.levels.INFO)

  vim.system(
    cmd,
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

-- Run fabric suggest_pattern on the input, extract the primary recommended
-- pattern name, then pipe the original text through that pattern.
function M.query_replace_fabric_auto(bufnr, start_line, end_line)
  local lines = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, end_line, true)
  local text = table.concat(lines, "\n")

  if text:match("^%s*$") then
    vim.notify("llm: empty input", vim.log.levels.WARN)
    return
  end

  vim.notify("llm: selecting pattern…", vim.log.levels.INFO)

  vim.system(
    { "fabric-ai", "-p", "suggest_pattern" },
    { text = true, stdin = text },
    vim.schedule_wrap(function(r1)
      if r1.code ~= 0 then
        vim.notify("llm error: " .. (r1.stderr or "non-zero exit"), vim.log.levels.ERROR)
        return
      end
      local pattern_name = (r1.stdout or ""):match("###[^`\n]*`([^`]+)`")
      if not pattern_name then
        vim.notify("llm: could not extract pattern name from suggest_pattern output", vim.log.levels.ERROR)
        return
      end

      vim.notify("llm: running pattern '" .. pattern_name .. "'…", vim.log.levels.INFO)

      vim.system(
        { "fabric-ai", "-p", pattern_name },
        { text = true, stdin = text },
        vim.schedule_wrap(function(r2)
          if r2.code ~= 0 then
            vim.notify("llm error: " .. (r2.stderr or "non-zero exit"), vim.log.levels.ERROR)
            return
          end
          local output = (r2.stdout or ""):gsub("\n$", "")
          local output_lines = vim.split(output, "\n", { plain = true })
          vim.api.nvim_buf_set_lines(bufnr, start_line - 1, end_line, true, output_lines)
          vim.notify("llm: done (" .. pattern_name .. ")", vim.log.levels.INFO)
        end)
      )
    end)
  )
end

return M

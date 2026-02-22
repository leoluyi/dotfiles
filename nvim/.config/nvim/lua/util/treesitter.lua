local M = {}

local has_match = function(to_mtach, match_table)
  for _, v in ipairs(match_table) do
    if v == to_mtach then
      return true
    end
  end
  return false
end

M.disable_file_handle = function(_, buf)
  local max_filesize = 1024000 -- 100 KB
  local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
  local filetype = vim.bo.filetype
  local file_ext = vim.fn.expand("%:e")
  local excluded_filetypes = {
    "",
    "html",
  }
  local excluded_ext = {
    "mp3",
    "mp4",
    "pdf",
    "jpg",
    "gif",
    "png",
  }

  if (ok and stats and stats.size > max_filesize)
    or has_match(filetype, excluded_filetypes)
    or has_match(file_ext, excluded_ext)
  then
    return true
  end
end


return M

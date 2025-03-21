local M = {}

function M.check()
  local start = vim.health.start
  local ok = vim.health.ok
  local error = vim.health.error

  start("gh-utils")

  if vim.fn.executable("gh") == 1 then
    ok("GitHub CLI (gh) is installed")
  else
    error("GitHub CLI (gh) not found. Install it from https://cli.github.com/")
  end

  if vim.fn.executable("git") == 1 then
    ok("git is installed")
  else
    error("git not found. Required for repository operations.")
  end

  local has_fugitive = vim.g.loaded_fugitive == 1
  if has_fugitive then
    ok("fugitive.vim is installed")
  else
    error("fugitive.vim not found. Required for git integration functionality.")
  end
end

return M

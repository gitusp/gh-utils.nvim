local M = {}

local function parse_buf_name(name)
  local wo_proto = string.sub(name, string.len("github-pulls://") + 1, string.len(name))
  local cwd_query = vim.split(wo_proto, "?", { plain = true })
  local cwd = cwd_query[1]
  local args = #cwd_query > 1 and vim.split(cwd_query[2], " ", { plain = true }) or {}

  return cwd, args
end

function M.merge(args)
  vim.notify("Merging PR...", vim.log.levels.INFO)
  local cmd = { 'gh', 'pr', 'merge' }
  for _, arg in ipairs(args) do
    table.insert(cmd, arg)
  end
  vim.system(cmd, nil, function(result)
    vim.schedule(function()
      if result.code == 0 then
        vim.notify("Successfully merged PR", vim.log.levels.INFO)
      else
        vim.notify("Failed to merge PR: " .. result.stderr, vim.log.levels.ERROR)
      end
    end)
  end)
end

function M.create(args)
  vim.notify("Creating PR...", vim.log.levels.INFO)
  local cmd = { 'gh', 'pr', 'create' }
  for _, arg in ipairs(args) do
    table.insert(cmd, arg)
  end
  vim.system(cmd, nil, function(result)
    vim.schedule(function()
      if result.code == 0 then
        vim.notify("Successfully created PR", vim.log.levels.INFO)
      else
        vim.notify("Failed to create: " .. result.stderr, vim.log.levels.ERROR)
      end
    end)
  end)
end

function M.review(branch)
  local result = vim.system({ 'git', 'merge-base', branch, 'HEAD' }):wait()
  if result.code ~= 0 then
    vim.notify("Failed to get merge-base", vim.log.levels.ERROR)
    return
  end

  local merge_base = result.stdout:gsub('%s+$', '')
  vim.cmd('Git difftool -y ' .. merge_base)
end

function M.open_pr(num)
  local cwd, _ = parse_buf_name(vim.fn.expand("%"))

  vim.system(
    {'gh', 'pr', 'view', num, '-w'},
    { cwd = cwd },
    function(result)
      if result.code ~=0 then
        vim.schedule(function()
          vim.notify("Failed to open PR #" .. num, vim.log.levels.ERROR)
        end)
      end
    end
  )
end

function M.init_pulls_buf()
  local buf = vim.api.nvim_get_current_buf()

  vim.api.nvim_buf_set_lines(buf, 0, 1, false, { 'loading...' })

  vim.api.nvim_set_option_value('filetype', 'github-pulls', { buf = buf })
  vim.api.nvim_set_option_value('buftype', 'nofile', { buf = buf })
  vim.api.nvim_set_option_value('bufhidden', 'hide', { buf = buf })
  vim.api.nvim_set_option_value('swapfile', false, { buf = buf })
  vim.api.nvim_set_option_value('readonly', true, { buf = buf })

  local cmd = {
    'gh', 'pr', 'list',
    '--json', 'number,title,author,headRefName,baseRefName,state',
    '--template', '{{range .}}#{{.number}} [{{.baseRefName}}] <- [{{.headRefName}}]\n{{.title}} by {{.author.login}} ({{.state}})\n\n{{end}}'
  }
  local cwd, args = parse_buf_name(vim.fn.expand("%"))
  for _, arg in ipairs(args) do
    if arg ~= '' then
      table.insert(cmd, arg)
    end
  end

  vim.system(
    cmd,
    { cwd = cwd },
    function(result)
      vim.schedule(function()
        if result.code ~= 0 then
          vim.notify("Failed to get PR list", vim.log.levels.ERROR)
          return
        end

        vim.api.nvim_set_option_value('readonly', false, { buf = buf })
        vim.api.nvim_buf_set_lines(buf, 0, 1, false, vim.split(result.stdout:gsub('%s+$', ''), '\n'))
        vim.api.nvim_set_option_value('readonly', true, { buf = buf })
      end)
    end
  )
end

return M

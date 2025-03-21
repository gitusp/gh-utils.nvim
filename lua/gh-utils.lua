local M

function M.merge(args)
  vim.notify("Merging current PR...", vim.log.levels.INFO)
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
  local url = vim.fn.expand("%")
  local cwd = string.sub(url, string.len("github-pulls://") + 1, string.len(url))

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

  vim.system({
    'gh', 'pr', 'list',
    '--json', 'number,title,author,headRefName,baseRefName',
    '--template', '{{range .}}#{{.number}} [{{.baseRefName}}] <- [{{.headRefName}}]\n{{.title}} by {{.author.login}}\n\n{{end}}'
  }, nil, function(result)
    vim.schedule(function()
      if result.code ~= 0 then
        vim.notify("Failed to get PR list", vim.log.levels.ERROR)
        return
      end

      vim.api.nvim_set_option_value('readonly', false, { buf = buf })
      vim.api.nvim_buf_set_lines(buf, 0, 1, false, vim.split(result.stdout:gsub('%s+$', ''), '\n'))
      vim.api.nvim_set_option_value('readonly', true, { buf = buf })
    end)
  end)
end

return M

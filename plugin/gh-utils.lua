if vim.g.loaded_gh_utils == 1 or vim.opt.compatible:get() then
  return
end

vim.g.loaded_gh_utils = 1

vim.api.nvim_create_user_command('PRMerge', function(opts)
  require("gh-utils").merge(opts.fargs)
end, { nargs = '*', desc = 'Run gh pr merge with given args' })

vim.api.nvim_create_user_command('PRReview', function(opts)
  require("gh-utils").review(opts.args)
end, { nargs = 1, desc = 'Open side-by-side diff buffers' })

vim.api.nvim_create_user_command('PRList', function()
  vim.cmd('vnew github-pulls://' .. vim.fn.getcwd())
end, { desc = 'List pull requests' })

vim.api.nvim_create_augroup('github', {})
vim.api.nvim_create_autocmd("BufReadCmd", {
  group = 'github',
  pattern = {"github-pulls://*"},
  callback = function()
    require("gh-utils").init_pulls_buf()
  end
})

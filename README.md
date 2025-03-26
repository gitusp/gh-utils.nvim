gh-utils.nvim
===

Github utilities for my personal use.

## Installation

For [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "gitusp/gh-utils.nvim",
  lazy = true,
  cmd = { "PRList", "PRReview", "PRMerge", "PRCreate" },
  ft = "github-pulls",
  -- Configure as you need
  opts = {
    merge_flags = { '-d', '-m' },
    create_flags = { '-f' },
  },
}
```

## Dependencies

- `git`, `gh` command
- [fugitive.vim](https://github.com/tpope/vim-fugitive)

## Commands

### PRList {args}

<img height="300" alt="PRList" src="https://github.com/user-attachments/assets/f673d60e-036c-499d-a8c3-0f9c96c4245f" />

Opens pull request list buffer.  
Given arguments are passed to `gh pr list` command.

| Kaymap | Location         | Keymaps                               |
|--------|------------------|---------------------------------------|
| `<CR>` | on a PR number   | Open the PR web page                  |
| `.`    | on a branch name | Populate cmdline with the branch name |

Also, reloading buffer with `:e` refreshes the list.

### PRReview {branch}

Open side-by-side diff buffers for reviewing between given branch and HEAD.

### PRMerge{!} {args}

Run `gh pr merge` with given arguments.  
Unless bang `!` specified, `opts.merge_flags` are appended at the end.  

### PRCreate{!} {args}

Run `gh pr create` with given arguments.  
Unless bang `!` specified, `opts.create_flags` are appended at the end.  

## Health Check

Run `:checkhealth gh-utils` to verify that all dependencies are properly installed.

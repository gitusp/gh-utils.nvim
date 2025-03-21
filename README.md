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
  ft = "github-pulls"
}
```

## Dependencies

- `git`, `gh` command
- [fugitive.vim](https://github.com/tpope/vim-fugitive)

## Commands

### PRList

Opens pull request list page.

| Kaymap | Location         | Keymaps                               |
|--------|------------------|---------------------------------------|
| `<CR>` | on a PR number   | Open the PR web page                  |
| `.`    | on a branch name | Populate cmdline with the branch name |

### PRReview {branch}

Open side-by-side diff buffers for reviewing between given branch and HEAD.

### PRMerge {args}

Run `gh pr merge` with given args.

### PRCreate {args}

Run `gh pr create` with given args.

## Setting Default Arguments to `PRMerge` and `PRCreate`

Just use `vim.cmd.abbrev`:

```lua
vim.cmd.abbrev('PRC', 'PRCreate -w')
vim.cmd.abbrev('PRM', 'PRMerge -d -m')
```

## Health Check

Run `:checkhealth gh-utils` to verify that all dependencies are properly installed.

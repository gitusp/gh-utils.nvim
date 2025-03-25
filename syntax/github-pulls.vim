syntax match githubPullsNumber "^#\d\+\ze \["
syntax match githubPullsBranchName "\[\zs[0-9a-zA-Z./-_]\+\ze\]"
syntax match githubPullsState "(\w\+)$"

highlight default link githubPullsNumber Underlined
highlight githubPullsBranchName guifg=green
highlight githubPullsState guifg=gray

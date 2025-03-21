syntax match githubPullsNumber "^#\d\+\ze \["
syntax match githubPullsBranchName "\[\zs[0-9a-zA-Z./-]\+\ze\]"

highlight default link githubPullsNumber Underlined
highlight githubPullsBranchName guifg=green

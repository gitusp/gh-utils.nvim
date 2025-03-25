nmap <buffer><silent> <cr> :call <SID>OpenPr()<CR>
nmap <buffer><silent> . :call <SID>PopulateCmdline()<CR>

function! s:OpenPr()
  if (line('.') - 1) % 3 == 0
    let l:line = getline(".")
    let l:col = col(".")
    let l:num = matchstr(l:line, '^#\zs\d\+\ze \[')
    if l:num != '' && l:col < len(l:num) + 2
      exec "lua require('gh-utils').open_pr(" .. l:num .. ")"
      return
    endif
  endif

  execute "norm! \<cr>"
endfunction

function! s:PopulateCmdline()
  if (line('.') - 1) % 3 == 0
    let l:line = getline(".")
    let l:col = col(".")
    let l:root_elms = split(l:line, "] <- [")

    if len(l:root_elms) == 2
      let l:front_elms = split(l:root_elms[0], '[')
      let l:col = l:col - len(l:front_elms[0])

      if l:col > 0
        let l:col = l:col - len('[') - len(front_elms[1])

        if l:col <= 1
          call feedkeys(': origin/' .. l:front_elms[1] .. "\<c-b>", 'n')
          return
        endif

        let l:col = l:col - len("] <- ")

        if l:col > 0
          call feedkeys(': origin/' .. l:root_elms[1][:-2] .. "\<c-b>", 'n')
          return
        endif
      endif
    endif
  endif

  execute "norm! ."
endfunction

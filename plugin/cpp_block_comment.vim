" Hacky plugin to create a textobj that represents a // block comment in C++
"
" Requires plugin 'kana/vim-textobj-user' and then this somewhere in your config:
"
" call textobj#user#plugin('cppblockcomment', {
"     \   '-': {
"     \     '*sfile*': expand('<sfile>:p'),
"     \     'select-a-function': 'GetLinesForBlockComment',
"     \     'select-a': 'ac',
"     \     'select-i-function': 'GetLinesForBlockComment',
"     \     'select-i': 'ic',
"     \   },
"     \ })
" 
" augroup cpp_textobjs
"   autocmd!
"   autocmd FileType cpp call textobj#user#map('cppblockcomment', {
"   \   '-': {
"   \     'select-a': '<buffer> ac',
"   \     'select-i': '<buffer> ic',
"   \   },
"   \ })
" augroup END
"
function! GetLinesForBlockComment()
    normal! 0
    let l:start_line = s:get_earliest_blank_line()

    if l:start_line <= 0
        return 0
    endif

    let l:start_pos = getpos('.')
    let l:start_pos[1] = l:start_line
    let l:end_line = s:get_last_blank_line(l:start_line)

    if l:end_line <= 0
        return 0
    endif

    let l:end_pos = deepcopy(l:start_pos)
    let l:end_pos[1] = l:end_line

    return ['V', l:start_pos, l:end_pos]
endfunction

function! s:get_earliest_blank_line()
    let l:line = line('.')
    while match(getline(l:line), "\s*\/\/") >= 0 && l:line > 0
        let l:line -= 1
    endwhile
    if l:line == line('.')
      return -1
    end
    return l:line + 1
endfunction

function! s:get_last_blank_line(i)
    let l:i = a:i
    while l:i <= line('$')
        if match(getline(l:i), "\s*\/\/") == -1
            break
        endif
        let l:i += 1
    endwhile
    return l:i > line('$') ? 0 : l:i - 1
endfunction

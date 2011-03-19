setl hls ro noma ignorecase

set syntax=vim

syn keyword vimCommand Bundle

nnoremap <buffer> <silent> <CR> :call vundle#scripts#install()<CR>
nnoremap <buffer> s :BundleSearch
nnoremap <buffer> c :BundleClean<CR>
nnoremap <buffer> C :BundleClean!<CR>

setl hls ro noma ignorecase

set syntax=vim

syn keyword vimCommand Bundle

nnoremap <buffer> i :call vundle#scripts#install()<CR>
nnoremap <buffer> r :Bundles 
nnoremap <buffer> c :BundleClean<CR>
nnoremap <buffer> C :BundleClean!<CR>
nnoremap <buffer> R :call vundle#scripts#reload()<CR>

syn keyword vimCommand Bundle

setl hls ro noma ignorecase syntax=vim

nnoremap <buffer> q :wincmd q<CR>
nnoremap <buffer> i :call vundle#scripts#install()<CR>
nnoremap <buffer> r :Bundles 
nnoremap <buffer> c :BundleClean<CR>
nnoremap <buffer> C :BundleClean!<CR>
nnoremap <buffer> R :call vundle#scripts#reload()<CR>

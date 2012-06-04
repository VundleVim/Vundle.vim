" local bundle directory to increase vim speed.
" set &rtp to make sure the localbundle &rtp is prior to $VIMRUNTIME
"
" TODO clear the bundle list after local updating.
"      or just don't add them to &rtp.

func! s:system(cmd) abort
  return system(a:cmd)
endf

function! vundle#local#update(bang) "{{{
    if a:bang
        exec "BundleInstall!"
    else
        exec "BundleInstall"
    endif

    cd ~/.vim
    if has('win32') || has('win64')
        let t = s:system("rd /S /Q localbundle")
    else
        let t = s:system("rm -rf localbundle")
    endif
    let t = 0==t ? "Success" : t
    echo "remove ~/.vim/localbundle\t:".t

    let t = s:system("mkdir localbundle")
    let t = 0==t ? "Success" : t
    echo "mkdir ~/.vim/localbundle\t:".t

    if has('win32') || has('win64')
        let dirs = split(glob("~/.vim/bundle/*"),"\n")
        let tar = expand("~/.vim/localbundle/")
        for dir in dirs
            exe "cd ".dir
            let t = s:system("xcopy /E /Y /C /I * ".tar)
        endfor
    else
        let t = s:system("cp -rnl bundle/*/* localbundle")
    endif
    let t = 0==t ? "Success" : t
    echo "copy to ~/.vim/localbundle\t:".t

    try
        helptags ~/.vim/localbundle/doc
        echo "helptags ~/.vim/localbundle\t:Success"
    catch
        echo "helptags ~/.vim/localbundle\t:".v:exception
    endtry

    echo "Local Updating Finish!"

endfunction "}}}

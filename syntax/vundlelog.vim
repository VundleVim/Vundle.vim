" ---------------------------------------------------------------------------
" Syntax highlighting for the line which identifies the plugin.
" ---------------------------------------------------------------------------
syntax match VundlePluginName '\v\C(Plugin )@<=\S+/\S+(\s|$)'
highlight link VundlePluginName Keyword

" ---------------------------------------------------------------------------
" Syntax highlighting for diffs on each plugin
" ---------------------------------------------------------------------------
syntax match VundleGitAddition '\v(\|\s*\d+ )@<=\++'
highlight VundleGitAddition guifg=darkgreen guibg=NONE gui=bold
    \ ctermfg=darkgreen ctermbg=NONE cterm=bold

syntax match VundleGitDeletion '\v(\|\s*\d+ \+*)@<=-+'
highlight VundleGitDeletion guifg=red guibg=NONE gui=bold ctermfg=red
    \ ctermbg=NONE cterm=bold

" ---------------------------------------------------------------------------
" Syntax highlighting for log-specific features
" ---------------------------------------------------------------------------
syntax match VundleCaret '\V >'
highlight link VundleCaret Label

" Make path to tags file stand out
syntax match VundleTagPath '\v\C(:helptags )@<=/\S+$'
highlight link VundleTagPath Comment

" Make URL stand out
syntax match VundleCompareUrl '\v\Chttps:\S+'
highlight link VundleCompareUrl Underlined

" Make errors (from git) stand out
syntax match VundleError '\v\C( \> )@<=fatal:.*$'
highlight link VundleError Error

" Make git messages stand out
syntax match VundleGitMsg '\v\C( \> )@<=git:.*$'
highlight link VundleGitMsg Type

" De-emphasize the time stamp
syntax match VundleTimeStamp '\m^\[\d\{4}-\d\{2}-\d\{2} \d\{2}:\d\{2}:\d\{2}]'
highlight link VundleTimeStamp String

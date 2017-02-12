" ---------------------------------------------------------------------------
" Syntax highlighting for the line which identifies the plugin.
" ---------------------------------------------------------------------------
syntax match VundlePluginName '\v(^Updated Plugin: )@<=.*$'
highlight link VundlePluginName Keyword

" ---------------------------------------------------------------------------
" Syntax highlighting for the 'compare at' line of each plugin.
" ---------------------------------------------------------------------------
syntax region VundleCompareLine start='\v^Compare at: https:' end='\v\n'
    \ contains=VundleCompareUrl
syntax match VundleCompareUrl '\vhttps:\S+'
highlight link VundleCompareLine Comment
highlight link VundleCompareUrl Underlined

" ---------------------------------------------------------------------------
" Syntax highlighting for individual commits.
" ---------------------------------------------------------------------------
" The main commit line.
" Note that this regex is intimately related to the one for VundleCommitTree,
" and the two should be changed in sync.
syntax match VundleCommitLine '\v(^  [|*]( *[\\|/\*])* )@<=[^*|].*$'
    \ contains=VundleCommitMerge,VundleCommitUser,VundleCommitTime
highlight link VundleCommitLine String
" Sub-regions inside the commit message.
syntax match VundleCommitMerge '\v Merge pull request #\d+.*'
syntax match VundleCommitUser '\v(   )@<=\S+( \S+)*(, \d+ \w+ ago$)@='
syntax match VundleCommitTime '\v(, )@<=\d+ \w+ ago$'
highlight link VundleCommitMerge Ignore
highlight link VundleCommitUser Identifier
highlight link VundleCommitTime Comment
" The git history DAG markers are outside of the main commit line region.
" Note that this regex is intimately related to the one for VundleCommitLine,
" and the two should be changed in sync.
syntax match VundleCommitTree '\v(^  )@<=[|*]( *[\\|/\*])*'
highlight link VundleCommitTree Label

" vundle - vim compatibility support module

" this abstracts the operation:
"  exec 'set runtimepath-='.vundle#compat#fnameescape(LIST)
"
" notes:
"  * it attempts to do the "real thing", if it can;
"   * otherwise, it has a number of fallback scenarios, ordered by
"      reliability;
"  * special case: if a:dirs contains a ',' (multiple entries), this function
"     attempts the
"      exec 'set runtimepath-='.vundle#compat#fnameescape(LIST)
"     first.
"     if that does not alter &runtimepath, then it tries to remove a:dirs
"     elements individually;
"
" args:
"  dirs [string]: described as 'LIST' above;
"
" for now, it does not produce an explicit return value
"
func! vundle#compat#rtp_rm_entry(dirs)
  " debug: echomsg '[debug] vundle#compat#rtp_rm_entry(): entered. rtp: ' . string(&rtp) . '; dirs: ' . string(a:dirs)
  " optimisation: there seems to be a few of these cases
  if empty(a:dirs)
    return 0
  endif
  let l:runtimepath_orig = &rtp
  let l:processed_flag = 0
  let l:elem_separator = ','
  for l:process_stage in range(1, 4)
    if ( l:process_stage == 1 )
      exec 'set rtp-='.vundle#compat#fnameescape(a:dirs)
      " if &rtp was altered, or a:dirs had only one element, we won't keep
      "  trying
      let l:processed_flag = ( ( &rtp != l:runtimepath_orig ) || ( stridx(a:dirs, l:elem_separator) < 0 ) )
    elseif ( l:process_stage == 2 )
      if exists('*split') && exists('*filter') && exists('*join')
        " a bit costly, but more compatible
        let l:runtimepath_list = split(&rtp, l:elem_separator, 1)

        for l:entry_dir in split(a:dirs, l:elem_separator, 1)
          let l:runtimepath_list = filter(l:runtimepath_list, 'v:val != l:entry_dir')
        endfor
        " assemble the runtime variable from the list
        let &rtp = join(l:runtimepath_list, l:elem_separator)
        let l:processed_flag = 1
      endif
    elseif ( l:process_stage == 3 )
      if exists('*escape')
        " from fnameescape() documentation:
        "  it escapes: " \t\n*?[{`$\\%#'\"|!<"
        "  plus, depending on 'isfname', other characters.
        "  (TODO: add those cases, if needed)
        exec 'set rtp-='.escape(a:dirs, " \t\n*?[{`$\\%#'\"|!<")
        let l:processed_flag = 1
      endif
    elseif ( l:process_stage == 4 )
      " cheap and cheerful (but no escaping)
      exec 'set rtp-='.a:dirs
      let l:processed_flag = 1
    endif
    if l:processed_flag
      break
    endif
  endfor
  " debug: echomsg '[debug] vundle#compat#rtp_rm_entry(): exiting. rtp: ' . string(&rtp)
endf

" abstracts the following operations:
"  exec 'set runtimepath^='.vundle#compat#fnameescape(LIST)
"  exec 'set runtimepath+='.vundle#compat#fnameescape(LIST)
"  exec 'set runtimepath='.vundle#compat#fnameescape(LIST)
"
" args:
"  dirs [string]: described as 'LIST' above;
"  addset_operator [string]: one of:
"   '^': prepend ('set runtimepath^=');
"   '+': append ('set runtimepath+=');
"   '':  set ('set runtimepath=');
"
" for now, it does not produce an explicit return value
"
func! vundle#compat#rtp_addset_entry(dirs, addset_operator)
  " debug: echomsg '[debug] vundle#compat#rtp_addset_entry(): entered. rtp: ' . string(&rtp) . '; dirs: ' . string(a:dirs) . '; operator: ' . string( a:addset_operator )
  if exists('*fnameescape')
    exec 'set rtp'.a:addset_operator.'='.fnameescape(a:dirs)
  else
    " a bit costly, but more compatible

    if ( a:addset_operator == '' ) && empty(&rtp)
      " this should be quick
      let &rtp = a:dirs
    else
      let l:elem_separator = ','

      " only add the elements not already present in &runtimepath
      if exists('*split') && exists('*filter') && exists('*join')
        " a bit costly, but more compatible
        let l:dirs_list = split(a:dirs, l:elem_separator, 1)
        for l:entry_dir in split(&rtp, l:elem_separator, 1)
          let l:dirs_list = filter(l:dirs_list, 'v:val != l:entry_dir')
        endfor
        let l:dirs = join(l:dirs_list, l:elem_separator)
      else
        " nothing we can do about this: we'll take the input as is
        let l:dirs = a:dirs
      endif

      if !empty(l:dirs)
        if a:addset_operator == '^'
          let &rtp = l:dirs . l:elem_separator . &rtp
        elseif a:addset_operator == '+'
          let &rtp = &rtp . l:elem_separator . l:dirs
        else
          " FIXME: report internal error
        endif
      endif
    endif
  endif
  " debug: echomsg '[debug] vundle#compat#rtp_addset_entry(): exiting. rtp: ' . string(&rtp)
endf

func! vundle#compat#has_dos_windows_paths()
  return exists('+shellslash')
endf

" provides the same functionality as shellescape()
"  (even on vim versions that don't support it)
"
" note: behaviour taken from vim-7.1 documentation
func! vundle#compat#shellescape(string_value)
  if vundle#compat#has_dos_windows_paths()
    if &shellslash
      " return as is?
      return a:string_value
    else
      " double all double quotes within string,
      "  and enclose result in double quotes
      return '"' . substitute(a:string_value,'"','""','g') . '"'
    endif
  else
    " replace all "'" with "'\''"
    return "'" . substitute(a:string_value,"'","'".'\\'."''",'g') . "'"
  endif
endf

"  (first appeared in a major release in vim-7.2)
let s:vundle_compat_has_fnameescape = exists( '*fnameescape' )
function vundle#compat#fnameescape( fname )
  " from documentation: it escapes: " \t\n*?[{`$\\%#'\"|!<"
  "  plus, depending on 'isfname', other characters.
  return ( s:vundle_compat_has_fnameescape ? fnameescape( a:fname ) : escape( a:fname, " \t\n*?[{`$\\%#'\"|!<" ) )
endfunction


" ---------------------------------------------------------------------------
" Search the database from vim-script.org for a matching plugin.  If no
" argument is given, list all plugins. This function is used by the :Plugins
" and :PluginSearch commands.
"
" ...  -- a plugin name to search for
" ---------------------------------------------------------------------------
func! vundle#search#new(string)
  let info = ['"Keymap: i - Install plugin; c - Cleanup; s - Search; R - Reload list']
  let url = s:search_url.'+'.a:string
  let query_result = s:search(url)
  " check error first
  if 0 == query_result[0]
    let false = 0
    let true = 0
    let null = 0
    let res = substitute(query_result[1], "\n", "", 'g')
    let items = eval(res).items
    " echo items
    call vundle#scripts#view('search', info, vundle#search#bundle_names(items))
    echo len(items).' plugins found'
  else
    call vundle#scripts#view('search', info, ['"An error running query'])
  endif
  redraw
endf

" ---------------------------------------------------------------------------
" Create a list of 'Plugin ...' lines from a list of bundle names.
"
" names  -- a list of names (strings) of plugins
" return -- a list of 'Plugin ...' lines suitable to be written to a buffer
" ---------------------------------------------------------------------------
func! vundle#search#bundle_names(items)
  let r = []
  for item in a:items
    call add(r, printf("Plugin '%s' \" %s", item.full_name, item.description))
  endfo
  return r
endf

" ---------------------------------------------------------------------------
"
" to     -- the filename (string) to save the database to
" url    -- the request url
" return -- 0 on success, 1 if an error occurred
" ---------------------------------------------------------------------------

func! s:search(url)
  let url = vundle#installer#shellesc(a:url)

  if executable("curl")
    let cmd = 'curl --fail -s '.l:url
  elseif executable("wget")
    let cmd = 'wget -q -O - '.l:url
  else
    echoerr 'Error curl or wget is not available!'
    return [1]
  endif

  let response = system(cmd)

  if (0 != v:shell_error)
    echoerr 'Error fetching scripts!'
  endif
  return [v:shell_error, response]
endf

let s:search_url = 'https://api.github.com/search/repositories?q=language:VimL+user:vim-scripts'

" vim: set expandtab sts=2 ts=2 sw=2 tw=78 norl:

" ---------------------------------------------------------------------------
" Add a plugin to the runtimepath.
"
" arg    -- a string specifying the plugin
" ...    -- a dictionary of options for the plugin
" return -- the return value from vundle#config#init_bundle()
" ---------------------------------------------------------------------------
func! vundle#config#bundle(arg, ...)
  let bundle = vundle#config#init_bundle(a:arg, a:000)
  if !s:check_bundle_name(bundle)
    return
  endif
  if exists('g:vundle#lazy_load') && g:vundle#lazy_load
    call add(g:vundle#bundles, bundle)
  else
    call s:rtp_rm_a()
    call add(g:vundle#bundles, bundle)
    call s:rtp_add_a()
    call s:rtp_add_defaults()
  endif
  return bundle
endf


" ---------------------------------------------------------------------------
"  When lazy bundle load is used (begin/end functions), add all configured
"  bundles to runtimepath and reorder appropriately.
" ---------------------------------------------------------------------------
func! vundle#config#activate_bundles()
  call s:rtp_add_a()
  call s:rtp_add_defaults()
endf


" ---------------------------------------------------------------------------
" Initialize Vundle.
"
" Start a new bundles list and make sure the runtimepath does not contain
" directories from a previous call. In theory, this should only be called
" once.
" ---------------------------------------------------------------------------
func! vundle#config#init()
  if !exists('g:vundle#bundles') | let g:vundle#bundles = [] | endif
  call s:rtp_rm_a()
  let g:vundle#bundles = []
  let s:bundle_names = {}
endf


" ---------------------------------------------------------------------------
" Add a list of bundles to the runtimepath and source them.
"
" bundles -- a list of bundle objects
" ---------------------------------------------------------------------------
func! vundle#config#require(bundles) abort
  for b in a:bundles
    call s:rtp_add(b.rtpath)
    call s:rtp_add(g:vundle#bundle_dir)
    " TODO: it has to be relative rtpath, not bundle.name
    exec 'runtime! '.b.name.'/plugin/*.vim'
    exec 'runtime! '.b.name.'/after/*.vim'
    call s:rtp_rm(g:vundle#bundle_dir)
  endfor
  call s:rtp_add_defaults()
endf


" ---------------------------------------------------------------------------
" Create a bundle object from a bundle specification.
"
" name   -- the bundle specification as a string
" opts   -- the options dictionary from then bundle definition
" return -- an initialized bundle object
" ---------------------------------------------------------------------------
func! vundle#config#init_bundle(name, opts)
  if a:name != substitute(a:name, '^\s*\(.\{-}\)\s*$', '\1', '')
    echo "Spurious leading and/or trailing whitespace found in plugin spec '" . a:name . "'"
  endif
  let opts = extend(s:parse_options(a:opts), s:parse_name(substitute(a:name,"['".'"]\+','','g')), 'keep')
  let b = extend(opts, copy(s:bundle))
  let b.rtpath = s:rtpath(opts)
  return b
endf


" ---------------------------------------------------------------------------
" Check if the current bundle name has already been used in this running
" instance and show an error to that effect.
"
" bundle -- a bundle object whose name is to be checked
" return -- 0 if the bundle's name has been seen before, 1 otherwise
" ---------------------------------------------------------------------------
funct! s:check_bundle_name(bundle)
  if has_key(s:bundle_names, a:bundle.name)
    echoerr 'Vundle error: Name collision for Plugin ' . a:bundle.name_spec .
          \ '. Plugin ' . s:bundle_names[a:bundle.name] .
          \ ' previously used the name "' . a:bundle.name . '"' .
          \ '. Skipping Plugin ' . a:bundle.name_spec . '.'
    return 0
  elseif a:bundle.name !~ '\v^[A-Za-z0-9_-]%(\.?[A-Za-z0-9_-])*$'
    echoerr 'Invalid plugin name: ' . a:bundle.name
    return 0
  endif
  let s:bundle_names[a:bundle.name] = a:bundle.name_spec
  return 1
endf


" ---------------------------------------------------------------------------
" Parse the options which can be supplied with the bundle specification.
" Corresponding documentation: vundle-plugins-configure
"
" opts   -- a dictionary with the user supplied options for the bundle
" return -- a dictionary with the user supplied options for the bundle, this
"           will be merged with a s:bundle object into one dictionary.
" ---------------------------------------------------------------------------
func! s:parse_options(opts)
  " TODO: improve this
  if len(a:opts) != 1 | return {} | endif

  if type(a:opts[0]) == type({})
    return a:opts[0]
  else
    return {'rev': a:opts[0]}
  endif
endf


" ---------------------------------------------------------------------------
" Parse the plugin specification.  Corresponding documentation:
" vundle-plugins-uris
"
" arg    -- the string supplied to identify the plugin
" return -- a dictionary with the folder name (key 'name') and the uri (key
"           'uri') for cloning the plugin  and the original argument (key
"           'name_spec')
" ---------------------------------------------------------------------------
func! s:parse_name(arg)
  let arg = a:arg
  let git_proto = exists('g:vundle_default_git_proto') ? g:vundle_default_git_proto : 'https'
  let git_host = git_proto == 'git' ? '@github.com:' : '://github.com/'

  if    arg =~? '^\s*\(gh\|github\):\S\+'
  \  || arg =~? '^[a-z0-9][a-z0-9-]*/[^/]\+$'
    let uri = git_proto.git_host.split(arg, ':')[-1]
    if uri !~? '\.git$'
      let uri .= '.git'
    endif
    let name = substitute(split(uri,'\/')[-1], '\.git\s*$','','i')
  elseif arg =~? '^\s*\(git@\|git://\)\S\+'
  \   || arg =~? '\(file\|https\?\)://'
  \   || arg =~? '\.git\s*$'
    let uri = arg
    let name = split( substitute(uri,'/\?\.git\s*$','','i') ,'\/')[-1]
  else
    let name = arg
    let uri  = git_proto.git_host.'vim-scripts/'.name.'.git'
  endif
  return {'name': name, 'uri': uri, 'name_spec': arg }
endf


" ---------------------------------------------------------------------------
"  Modify the runtimepath, after all bundles have been added, so that the
"  directories that were in the default runtimepath appear first in the list
"  (with their 'after' directories last).
" ---------------------------------------------------------------------------
func! s:rtp_add_defaults()
  let current = &rtp
  set rtp&vim
  let default = &rtp
  let &rtp = current
  let default_rtp_items = split(default, ',')
  if !empty(default_rtp_items)
    let first_item = fnameescape(default_rtp_items[0])
    exec 'set rtp-=' . first_item
    exec 'set rtp^=' . first_item
  endif
endf


" ---------------------------------------------------------------------------
" Remove all paths for the plugins which are managed by Vundle from the
" runtimepath.
" ---------------------------------------------------------------------------
func! s:rtp_rm_a()
  let paths = map(copy(g:vundle#bundles), 'v:val.rtpath')
  let prepends = join(paths, ',')
  let appends = join(paths, '/after,').'/after'
  exec 'set rtp-='.fnameescape(prepends)
  exec 'set rtp-='.fnameescape(appends)
endf


" ---------------------------------------------------------------------------
" Add all paths for the plugins which are managed by Vundle to the
" runtimepath.
" ---------------------------------------------------------------------------
func! s:rtp_add_a()
  let paths = map(copy(g:vundle#bundles), 'v:val.rtpath')
  let prepends = join(paths, ',')
  let appends = join(paths, '/after,').'/after'
  exec 'set rtp^='.fnameescape(prepends)
  exec 'set rtp+='.fnameescape(appends)
endf


" ---------------------------------------------------------------------------
" Remove a directory and the corresponding 'after' directory from runtimepath.
"
" dir    -- the directory name to be removed as a string.  The corresponding
"           'after' directory will also be removed.
" ---------------------------------------------------------------------------
func! s:rtp_rm(dir) abort
  exec 'set rtp-='.fnameescape(expand(a:dir, 1))
  exec 'set rtp-='.fnameescape(expand(a:dir.'/after', 1))
endf


" ---------------------------------------------------------------------------
" Add a directory and the corresponding 'after' directory to runtimepath.
"
" dir    -- the directory name to be added as a string.  The corresponding
"           'after' directory will also be added.
" ---------------------------------------------------------------------------
func! s:rtp_add(dir) abort
  exec 'set rtp^='.fnameescape(expand(a:dir, 1))
  exec 'set rtp+='.fnameescape(expand(a:dir.'/after', 1))
endf


" ---------------------------------------------------------------------------
" Expand and simplify a path.
"
" path   -- the path to expand as a string
" return -- the expanded and simplified path
" ---------------------------------------------------------------------------
func! s:expand_path(path) abort
  return simplify(expand(a:path, 1))
endf


" ---------------------------------------------------------------------------
" Find the actual path inside a bundle directory to be added to the
" runtimepath.  It might be provided by the user with the 'rtp' option.
" Corresponding documentation: vundle-plugins-configure
"
" opts   -- a bundle dict
" return -- expanded path to the corresponding plugin directory
" ---------------------------------------------------------------------------
func! s:rtpath(opts)
  return has_key(a:opts, 'rtp') ? s:expand_path(a:opts.path().'/'.a:opts.rtp) : a:opts.path()
endf


" ---------------------------------------------------------------------------
" a bundle 'object'
" ---------------------------------------------------------------------------
let s:bundle = {}


" ---------------------------------------------------------------------------
" Return the absolute path to the directory inside the bundle directory
" (prefix) where thr bundle will be cloned.
"
" return -- the target location to clone this bundle to
" ---------------------------------------------------------------------------
func! s:bundle.path()
  return s:expand_path(g:vundle#bundle_dir.'/') . self.name
endf


" ---------------------------------------------------------------------------
"  Determine if the bundle has the pinned attribute set in the config
"
"  return -- 1 if the bundle is pinned, 0 otherwise
" ---------------------------------------------------------------------------
func! s:bundle.is_pinned()
  return get(self, 'pinned')
endf

" vim: set expandtab sts=2 ts=2 sw=2 tw=78 norl:

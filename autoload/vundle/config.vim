func! vundle#config#bundle(spec, ...)
  let bundle = vundle#config#init_bundle(a:spec, a:000)
  " All bundles are removed from rtp and re-added in inverse order so that
  " they appear in rtp in the same order as they appear in vimrc
  call g:bundles.rm_from_rtp()
  call g:bundles.add(bundle)
  call g:bundles.add_to_rtp()
endf

" Clear all bundles from rtp, create the bundles holder
"
func! vundle#config#init()
  if exists('g:bundles')
      call g:bundles.rm_from_rtp()
  endif
  let g:bundles = s:bundles.new()
endf


" Add each bundle to rtp and run their plugins, similarly to what vim does at
" startup.
"
func! vundle#config#require(bundles) abort
  for bundle in a:bundles
    call s:rtp_add(bundle.rtpath())
    call s:rtp_add(g:bundle_dir)
    " TODO: it has to be relative rtpath, not bundle.name
    exec 'runtime! ' . bundle.name . '/plugin/*.vim'
    exec 'runtime! ' . bundle.name . '/after/*.vim'
    call s:rtp_rm(g:bundle_dir)
  endfor
endf


" Create a bundle object based on a given spec and options
func! vundle#config#init_bundle(spec, opts)
  let spec = substitute(a:spec,"['".'"]\+','','g')

  " Combine info derived from the spec with the options from the Bundle
  " command.
  let opts = extend(s:parse_options(a:opts), s:parse_spec(spec))

  " Include generic bundle methods
  return extend(opts, copy(s:bundle))
endf

func! s:parse_options(opts)
  " TODO: improve this
  if len(a:opts) != 1 | return {} | endif

  if type(a:opts[0]) == type({})
    return a:opts[0]
  else
    return {'rev': a:opts[0]}
  endif
endf

func! s:parse_spec(spec)
  let spec = a:spec

  if    spec =~? '^\s*\(gh\|github\):\S\+'
  \  || spec =~? '^[a-z0-9][a-z0-9-]*/[^/]\+$'
    let uri = 'https://github.com/'.split(spec, ':')[-1]
    if uri !~? '\.git$'
      let uri .= '.git'
    endif
    let name = substitute(split(uri,'\/')[-1], '\.git\s*$','','i')
  elseif spec =~? '^\s*\(git@\|git://\)\S\+'
  \   || spec =~? '\(file\|https\?\)://'
  \   || spec =~? '\.git\s*$'
    let uri = spec
    let name = split( substitute(uri,'/\?\.git\s*$','','i') ,'\/')[-1]
  else
    let name = spec
    let uri  = 'https://github.com/vim-scripts/'.name.'.git'
  endif
  return {'name': name, 'uri': uri, 'spec': spec }
endf


func! s:rtp_rm(dir) abort
  exec 'set rtp-='.fnameescape(expand(a:dir))
  exec 'set rtp-='.fnameescape(expand(a:dir.'/after'))
endf

func! s:rtp_add(dir) abort
  exec 'set rtp^='.fnameescape(expand(a:dir))
  exec 'set rtp+='.fnameescape(expand(a:dir.'/after'))
endf

func! s:expand_path(path) abort
  return simplify(expand(a:path))
endf


" Bundle object
" ---------------------------------------------------------------------------
let s:bundle = {}

func! s:bundle.path()
  return s:expand_path(g:bundle_dir.'/'.self.name)
endf

func! s:bundle.rtpath()
  return has_key(self, 'rtp') ? s:expand_path(self.path().'/'.self.rtp) : self.path()
endf

func! s:bundle.command()
  return printf("Bundle '%s'", self.spec)
endf

" ---------------------------------------------------------------------------


" Bundle collection object
" ---------------------------------------------------------------------------
"
let s:bundles = { 'list' : [], 'dict' : {} }

function! s:bundles.add(bundle)
    call add(self.list, a:bundle.spec )
    let self.dict[ a:bundle.spec ] = a:bundle
endf

func! s:bundles.new()
    return deepcopy(self)
endf

func! s:bundles.keys()
  return copy(self.list)
endf

func! s:bundles.has_bundle(spec)
  return has_key(self.dict, a:spec)
endf

func! s:bundles.get(bundle_spec)
  return get(self.dict, a:bundle_spec)
endf

func! s:bundles.rm_from_rtp()
  call map(copy(self.list), 's:rtp_rm(self.dict[v:val].rtpath())')
endf

func! s:bundles.add_to_rtp()
  call map(reverse(copy(self.list)), 's:rtp_add(self.dict[v:val].rtpath())')
endf

func! s:bundles.get_sorted_list()
  return map(copy(self.list), 'self.dict[v:val]')
endf

func! s:bundles.size()
  return len(self.list)
endf

" ---------------------------------------------------------------------------

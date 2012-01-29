func! vundle#config#bundle(arg, ...)
  let bundle = vundle#config#init_bundle(a:arg, a:000)
  call s:rtp_rm_a()
  call add(g:bundles, bundle)
  call s:rtp_add_a()
  return bundle
endf

func! vundle#config#init()
  if !exists('g:bundles') | let g:bundles = [] | endif
  call s:rtp_rm_a()
  let g:bundles = []
endf

func! vundle#config#require(bundles) abort
  for b in a:bundles
    call s:rtp_add(b.rtpath())
    call s:rtp_add(g:bundle_dir)
    " TODO: it has to be relative rtpath, not bundle.name
    exec 'runtime! '.b.name.'/plugin/*.vim'
    exec 'runtime! '.b.name.'/after/*.vim'
    call s:rtp_rm(g:bundle_dir)
  endfor
endf

func! vundle#config#init_bundle(name, opts)
  let opts = extend(s:parse_options(a:opts), s:parse_name(substitute(a:name,"['".'"]\+','','g')))
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

func! s:parse_name(arg)

  let git_proto = exists('g:vundle_default_git_proto') ? g:vundle_default_git_proto : 'https'

  " default to git
  let type = 'git'

  " mercurial
  if a:arg[:3] ==# 'bit:'
      " bit:{N}/{repo}      {"type": "hg", "uri": "http://bitbucket.org/{Name}/{repo}}
      let uri = 'https://bitbucket.org/'.a:arg[len('bit:'):]
      let name = split(uri,'\/')[-1]
      let type = 'hg'
  elseif a:arg[:2]==#'hg:'
      " hg:{uri}          {"type": "hg", "uri": {uri}}
      let uri = a:arg[len('hg:'):]
      let name = split(uri,'\/')[-1]
      let type = 'hg'
      " bazaar
  elseif a:arg[:2]==#'lp:'
      let uri = a:arg
      let name = split (uri, ':')[-1]
      let type = 'bzr'
      " git
  elseif a:arg =~? '^\s*\(gh\|github\):\S\+'
              \  || a:arg =~? '^[a-z0-9][a-z0-9-]*/[^/]\+$'
      " github|gh:{N}/{Repo}  {"type": "git", "uri": "git://github.com/{N}/{Repo}"}
      let uri = git_proto.'://github.com/'.split(a:arg, ':')[-1]
      if uri !~? '\.git$'
          let uri .= '.git'
      endif
      let name = substitute(split(uri,'\/')[-1], '\.git\s*$','','i')
  elseif a:arg =~? '^\s*\(git@\|git://\)\S\+' 
              \   || a:arg =~? '\(file\|https\?\)://'
              \   || a:arg =~? '\.git\s*$'
      " git|https:{uri}          {"type": "git", "uri": {uri}}
      let uri = a:arg
      let name = split( substitute(uri,'/\?\.git\s*$','','i') ,'\/')[-1]
  else
      let name = a:arg
      let uri  = git_proto.'://github.com/vim-scripts/'.name.'.git'
  endif
  return {'name': name, 'uri': uri, 'name_spec': a:arg, 'type':type }
  endf

func! s:rtp_rm_a()
  call filter(copy(g:bundles), 's:rtp_rm(v:val.rtpath())')
endf

func! s:rtp_add_a()
  call filter(reverse(copy(g:bundles)), 's:rtp_add(v:val.rtpath())')
endf

func! s:rtp_rm(dir) abort
  exec 'set rtp-='.fnameescape(expand(a:dir, 1))
  exec 'set rtp-='.fnameescape(expand(a:dir.'/after', 1))
endf

func! s:rtp_add(dir) abort
  exec 'set rtp^='.fnameescape(expand(a:dir, 1))
  exec 'set rtp+='.fnameescape(expand(a:dir.'/after', 1))
endf

func! s:expand_path(path) abort
  return simplify(expand(a:path, 1))
endf

let s:bundle = {}

func! s:bundle.path()
  return s:expand_path(g:bundle_dir.'/'.self.name)
endf

func! s:bundle.rtpath()
  return has_key(self, 'rtp') ? s:expand_path(self.path().'/'.self.rtp) : self.path()
endf

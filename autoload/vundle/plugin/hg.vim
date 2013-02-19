func! vundle#plugin#hg#parse_name(name_spec, plugin, uri)
	return {'name': matchstr(a:uri, '[a-z0-9-]\+$'), 'uri': a:uri, 'name_spec': a:name_spec, 'plugin': a:plugin }
endf

func! vundle#plugin#hg#sync(bang, bundle)
	let hg_dir = expand(a:bundle.path().'/.hg/', 1)
	if isdirectory(hg_dir) || filereadable(expand(a:bundle.path().'/.hg', 1))
		if !(a:bang) | return 'todate' | endif
		let cmd = 'cd '.shellescape(a:bundle.path()).' && hg pull && hg up -C'

		let cmd = g:shellesc_cd(cmd)

		let get_current_sha = 'cd '.shellescape(a:bundle.path()).' && hg identify -i'
		let get_current_sha = g:shellesc_cd(get_current_sha)
		let initial_sha = vundle#installer#system(get_current_sha)[0:15]
	else
		let cmd = 'hg clone '.shellescape(a:bundle.uri).' '.shellescape(a:bundle.path())
		let initial_sha = ''
	endif

	let out = vundle#installer#system(cmd)
	call vundle#installer#log('')
	call vundle#installer#log('Bundle '.a:bundle.name_spec)
	call vundle#installer#log('$ '.cmd)
	call vundle#installer#log('> '.out)

	if 0 != v:shell_error
		return 'error'
	end

	if empty(initial_sha)
		return 'new'
	endif

	let updated_sha = vundle#installer#system(get_current_sha)[0:15]

	if initial_sha == updated_sha
		return 'todate'
	endif

	call add(g:updated_bundles, [initial_sha, updated_sha, a:bundle])
	return 'updated'
endf

func! vundle#plugin#hg#create_changelog(bundle, initial_sha, updated_sha)
	return 'Update log not accessible!'
endf

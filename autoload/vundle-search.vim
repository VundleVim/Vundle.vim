let scripts=tempname() | exec '!curl http://vim-scripts.org/scripts.html >'.scripts
exec 'e '.scripts
%s/<tr>\_.\s\+<td>\(\d\+\)<\/td>\_.\s\+<td>\([^<]\+\)<\/td>\_\s\+<td><a\s\+href="\([^"]\+\)">\([^<\/]\+\)<\/a><\/td>\_\s\+<td>\(.*\)<\/td>/Script:\1 \2 \4 \3 \5/g


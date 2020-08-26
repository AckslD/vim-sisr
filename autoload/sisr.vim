" Credit goes `jjaderberg` for the answer https://vi.stackexchange.com/a/4265
" which this plugin builds on.

" Get the current syntax names
function sisr#get_current_regions()
    let l:synNames = []
    for id in synstack(line("."), col("."))
        call add(l:synNames, synIDattr(id, "name"))
    endfor

    return l:synNames
endfunction

" Returns string to put in location list at current cursor
function! sisr#get_list_entry()
    return join([expand("%:"), line("."), col("."), getline(".")], ":")
endfunction

" Check if the cursor is currently in the specified region
function! sisr#is_in_region(regionPattern)
    for id in synstack(line("."), col("."))
        if synIDattr(id, "name") =~? a:regionPattern
            return 1
        endif
    endfor

    return 0
endfunction

" Get all matches of pattern in all regions with names in regions while
" ignoring those in ignores
function! sisr#syntax_regions_search(regionPattern, searchPattern, ignorePattern)

    " Save the current position for later
    let l:originalPos = getpos(".")

    " Find all matches within regions
    let l:matches = []
    while search(a:searchPattern, "W")
        if !sisr#is_in_region(a:ignorePattern) && sisr#is_in_region(a:regionPattern)
            call add(l:matches, sisr#get_list_entry())
        endif
    endwhile

    " Populate the location list
    lexpr join(l:matches ,"\n")

    if len(l:matches) ># 0
        " Open localion list window
        lopen

        " Go back to previous window
        execute "normal! \<c-w>\<c-p>"
    else
        " Reset the cursor
        call cursor(l:originalPos[1],l:originalPos[2])
    endif
endfunction

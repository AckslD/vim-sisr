" Returns string to put in location list at current cursor
function! sisr#get_list_entry()
    return join([expand("%:"), line("."), col("."), getline(".")], ":")
endfunction

" Finds all matches of pattern in last visual selection
function! sisr#get_matches_in_visual(pattern)
    " Go to start of last visual selection
    execute "normal! \<esc>`<"
    " Find all matches
    let l:matches = []
    while search("\\v%V" . a:pattern, "eW")
        call add(l:matches, sisr#get_list_entry())
    endwhile
    " Go to end of last visual selection
    execute "normal! `>"

    return l:matches
endfunction

" Visual select the next region based on the start-, end- and ignore-patterns
function! sisr#visual_select_next_region(startPattern, endPattern, ignore)
    if strlen(a:ignore) ># 0
        let l:ignorePattern = "\\v%(^.{-}" . a:ignore . ".{-})@<!"
    else
        let l:ignorePattern = "\\v"
    endif
    let l:startSearchResult = search(l:ignorePattern . a:startPattern, "zeW")
    if l:startSearchResult ==# 0
        return 0
    endif
    " NOTE removes any previous selection by user
    " Visual select until end pattern
    execute "normal! v"
    let l:endSearchResult = search(l:ignorePattern . a:endPattern, "zW")
    if l:endSearchResult ==# 0
        echoerr "Could not find end-pattern: " . a:endPattern
        return -1
    endif

    return l:startSearchResult
endfunction

" Get all matches of pattern in all regions based on the start-, end- and ignore-patterns
function! sisr#get_matches_in_regions(startPattern, endPattern, pattern, ignore)
    let l:matches = []
    while sisr#visual_select_next_region(a:startPattern, a:endPattern, a:ignore)
        let l:matches += sisr#get_matches_in_visual(a:pattern)
    endwhile

    return l:matches
endfunction

" Get all matches of pattern in all regions defined by regionPatterns
function! sisr#syntax_regions_search(regionPatterns, pattern, ignore)
    " Save the current position for later
    let l:originalPos = getpos(".")


    " Find all matches within regions
    let l:matches = []
    for regionPattern in a:regionPatterns
        " Go to start of document
        execute "normal! gg"
        let l:matches += sisr#get_matches_in_regions(regionPattern[0], regionPattern[1], a:pattern, a:ignore)
    endfor

    " Sort the matches
    let l:matches = sort(l:matches)

    " Populate the location list
    lexpr join(l:matches ,"\n")

    " Reset the cursor
    call cursor(l:originalPos[1],l:originalPos[2])

    " Open localion list window
    lopen

    " Go back to previous window
    execute "normal! \<c-w>\<c-p>"
endfunction

function! sisr#syntax_region_search(startPattern, endPattern, pattern, ignore)
    call sisr#syntax_regions_search([a:startPattern, a:endPattern], a:pattern, a:ignore)
endfunction

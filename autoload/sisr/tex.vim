function! sisr#tex#eq(pattern)
    let l:regionPattern = "texMathZone."
    let l:ignorePattern = "texComment"
    call sisr#syntax_regions_search(l:regionPattern, a:pattern, l:ignorePattern)
endfunction

function! sisr#tex#inline_eq(pattern)
    let l:inlineStart = "\\$"
    let l:inlineEnd = "\\$"
    let l:comment = "\\%"
    call sisr#syntax_region_search(l:inlineStart, l:inlineEnd, a:pattern, l:comment)
endfunction

function! sisr#tex#eq(pattern)
    let l:inlinePattern = ["\\$", "\\$"]
    let l:envPattern = ["\\\\begin\\{equation\\*?\\}", "\\\\end\\{equation\\*?\\}"]
    let l:comment = "\\%"
    call sisr#syntax_regions_search([l:inlinePattern, l:envPattern], a:pattern, l:comment)
endfunction

# SISR: Search In Syntax Regions

The idea for this plugin started when I wanted to search for a pattern but only inside equation-regions in a tex-document.
I found an [answer](https://vi.stackexchange.com/a/4265) by `jjaderberg` on StackExchange and thought I would turn this into a plugin with some extended functionality.

This plugin provides commands to search within specified syntax regions.
One specifies these regions by the name of the syntax item.
The matches of the search are populated in the location list which can be traversed using `lnext` and `lprevious`.

This plugin is in its infancy (and is my first public one), so all contribution and thoughts are welcome.
There is currently one generic command to perform any search by specifying the regions to look for and one dedicated to search for a pattern within tex math-environments.

# Installation
Use your favourite plugin manager, for example [`vim-plug`](https://github.com/junegunn/vim-plug):
```vim
Plug 'AckslD/vim-sisr'
```

# Usage
## Tex
To search for for example `x` only within math-regions of a tex document, do:
```
:SisrTexEq x
```
which by default ignores any comments (starting with `%`).
This will open the [locator list window](https://freshman.tech/vim-quickfix-and-location-list/) and you can traverse the matches by using `:lnext` and `lprevious` which you can optionally bind to some keys.

## General
To search inside a custom syntax region use the command `Sisr`.
The `Sisr`-command takes three arguments (separated by space):

1. `regionPattern`: Name of regions to include (can be regex), e.g. "texMathZone.".
1. `searchPattern`: The pattern to search for within the region.
1. `ignorePattern`: Name of regions to exclude even if currently in `regionPattern` (can be regex),
    e.g. "texComment".

To for example search for `Einstein` within `\cite{...}`-regions, do:
```vim
Sisr texCite Einstein texComment
```

If you want to do this often you can create your own dedicated function and command by for example:
```vim
function! SisrTexCite(pattern)
    let l:regionPattern = "texCite"
    let l:ignorePattern = "texComment"
    call sisr#syntax_regions_search(l:regionPattern, a:pattern, l:ignorePattern)
endfunction

command! -nargs=1 SisrTexCite call SisrTexCite(<f-args>)
```

To find out what certain syntax regions are called you can use the function `sisr#get_current_regions` to get the names of the regions at the current cursor location.

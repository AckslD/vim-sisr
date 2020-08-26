# SISR: Search In Syntax Regions

The idea for this plugin started when I wanted to search for a pattern but only inside equation-regions in a tex-document.
I tried to find out if there was already a simple way to do this but couldn't find anything, except some ad-hoc answers on StackExchange.

This plugin provides commands to search within specified syntax regions.
One specifies these regions by a regex-pattern and can also ignore certain lines which for example are comments.
The start- and end-pattern of a region do not need to be different, for example as in tex where inline-math starts and ends with `$`.
The matches of the search are populated in the location list which can be traversed using `lnext` and `lprevious`.

This plugin is in its infancy (and is my first public one), so all contribution and thoughts are welcome.
There is currently one generic command to perform any search by specifying the regions to look for and one dedicated to search for a pattern within tex math-environments (both `$..$` and `\begin{equation}...\end{equation}`).

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
The `Sisr`-command takes four arguments (separated by space):

1. `startPattern`: Pattern which the region starts with.
1. `endPattern`: Pattern which the region starts with.
1. `pattern`: The pattern to search for within the region.
1. `ignore`: Ignore lines starting with this pattern.

These patterns will use vims [very-magic](https://vim.fandom.com/wiki/Simplifying_regular_expressions_using_magic_and_no-magic) so for example `{}`-brackets needs to be escaped.
Furthermore, any backslashes need to be escaped additionally.
So if one wants to search for the backslash-caracter, then 4(!) backslashes needs to be given.

To for example search for `Einstein` within `\cite{...}`-regions, do:
```vim
Sisr \\\\cite\\{ \\} Einstein \\%
```

If you want to do this often you can create your own dedicated function and command by for example:
```vim
function! SisrTexCite(pattern)
    let l:startPattern = "\\\\cite\\{"
    let l:endPattern = "\\}"
    let l:comment = "\\%"
    call sisr#syntax_region_search(l:startPattern, l:endPattern, a:pattern, l:comment)
endfunction

command! -nargs=1 SisrTexCite call SisrTexCite(<f-args>)
```

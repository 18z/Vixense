let g:zdict_query_key = '<leader>z'
execute 'nnoremap <silent> '. g:zdict_query_key .' :call Sixense()<CR>'

function! Sixense()
    let word = s:get_word()
python << EOF
import vim
import time
import pyperclip
import sys
sys.path.append('/home/deanboole/Documents/Vixense')

from core.parser import __parser__
from core.plugins import __modules__

clipboard_content = pyperclip.paste()

def process(clipboard_content):

    if __parser__.url(clipboard_content) is True:
        __modules__['print_url'].run(clipboard_content)
    elif __parser__.timestamp(clipboard_content) is True:
        __modules__['print_timestamp'].run(clipboard_content)
    else:
        print clipboard_content + " ----->>  not in patterns"

process(vim.eval("word"))
EOF
endfunc


function! s:get_word () " {{{
    let l:mode = mode()

    if l:mode == 'n'
        return expand('<cWORD>')
    elseif l:mode == 'v' || l:mode == 'V' || l:mode == ""
        if line("'<") != line("'>")
            return ''
        endif
        return getline('.')[(col("'<") - 1):(col("'>") - 1)]
    elseif l:mode == 'i'
        let l:linetext = getline('.')
        let l:right = col('.') - 1
        let l:left = l:right
        while l:left > 1
            if l:linetext[(l:left - 1)] ==# ' '
                let l:left = l:left + 1
                break
            endif
            let l:left = l:left - 1
            echom l:linetext[(l:left - 1):(l:right - 1)]
        endwhile
        return l:linetext[(l:left - 1):(l:right - 1)]
    endif

    return expand('<cWORD>')
endfunction " }}}

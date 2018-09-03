let s:signs = {
    \ 'python': '#',
    \ 'c': '//',
    \ 'cpp': '//',
    \ 'go': '//',
    \ 'yaml': '#'
    \}

function! s:comment(line, indent, comment)
    call cursor(a:line, a:indent + 1)
    exec printf('normal! i%s ', a:comment)
endfunction

function! s:uncomment(line, comment)
    call cursor(a:line, 1)
    exec printf(':silent! s/\(^\s*\)\@<=%s\s//', a:comment)
endfunction

function! Comment(mode) range
    if !has_key(s:signs, &ft)
        return
    endif

    let c = s:signs[&ft]

    if a:mode == 'n'
        let x = col('.')
        let a = line('.')

        let n = indent(l:a)
        call s:comment(l:a, l:n, l:c)
    else
        let x = col("'<")

        let a = line("'<")
        let b = line("'>")
        let n = 1000

        let i = l:a
        while i <= l:b
            let k = indent(l:i)
            if l:k < l:n
                let n = l:k
            endif
            let i = l:i + 1
        endwhile

        let i = l:a
        while i <= l:b
            call s:comment(l:i, l:n, l:c)
            let i = l:i + 1
        endwhile
    endif

    call cursor(l:a, l:x)
endfunction

function! Uncomment(mode)
    if !has_key(s:signs, &ft)
        return
    endif

    let c = s:signs[&ft]

    if a:mode == 'n'
        let x = col('.')
        let a = line('.')
        call s:uncomment(l:a, l:c)
    else
        let x = col("'<")
        let a = line("'<")
        let b = line("'>")

        let i = l:a
        while i <= l:b
            call s:uncomment(l:i, l:c)
            let i = l:i + 1
        endwhile
    endif

    call cursor(l:a, l:x)
endfunction
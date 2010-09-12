" Vim indent file
" Language:	Lettuce
" Maintainer:	Yuri Malheiros <contato@yurimalheiros.com>
" Last Change:	2010 Sep 22
" This indent file is based on Cucumber indent file by Tim Pope

if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal autoindent
setlocal indentexpr=GetLettuceIndent()
setlocal indentkeys=o,O,*<Return>,<:>,0<Bar>,0#,=,!^F

" Only define the function once.
if exists("*GetLettuceIndent")
  finish
endif

function! s:syn(lnum)
  return synIDattr(synID(a:lnum,1+indent(a:lnum),1),'name')
endfunction

function! GetLettuceIndent()
  let line  = getline(prevnonblank(v:lnum-1))
  let cline = getline(v:lnum)
  let syn = s:syn(prevnonblank(v:lnum-1))
  let csyn = s:syn(v:lnum)
  if csyn ==# 'lettuceFeature' || cline =~# '^\s*Feature:'
    return 0
  elseif csyn ==# 'lettuceExamples' || cline =~# '^\s*\%(Examples\|Scenarios\):'
    return 2 * &sw
  elseif csyn =~# '^lettuce\%(Background\|Scenario\|ScenarioOutline\)$' || cline =~# '^\s*\%(Background\|Scenario\|Scenario Outline\):'
    return &sw
  elseif syn ==# 'lettuceFeature' || line =~# '^\s*Feature:'
    return &sw
  elseif syn ==# 'lettuceExamples' || line =~# '^\s*\%(Examples\|Scenarios\):'
    return 3 * &sw
  elseif syn =~# '^lettuce\%(Background\|Scenario\|ScenarioOutline\)$' || line =~# '^\s*\%(Background\|Scenario\|Scenario Outline\):'
    return 2 * &sw
  elseif cline =~# '^\s*@' && (s:syn(nextnonblank(v:lnum+1)) == 'lettuceFeature' || getline(nextnonblank(v:lnum+1)) =~# '^\s*Feature:' || indent(prevnonblank(v:lnum-1)) <= 0)
    return 0
  elseif line =~# '^\s*@'
    return &sw
  elseif cline =~# '^\s*|' && line =~# '^\s*|'
    return indent(prevnonblank(v:lnum-1))
  elseif cline =~# '^\s*|' && line =~# '^\s*[^|#]'
    return indent(prevnonblank(v:lnum-1)) + &sw
  elseif cline =~# '^\s*[^|# \t]' && line =~# '^\s*|'
    return indent(prevnonblank(v:lnum-1)) - &sw
  elseif cline =~# '^\s*$' && line =~# '^\s*|'
    let in = indent(prevnonblank(v:lnum-1))
    return in == indent(v:lnum) ? in : in - &sw
  elseif cline =~# '^\s*#' && getline(v:lnum-1) =~ '^\s*$' && getline(v:lnum+1) =~# '\S'
    return indent(getline(v:lnum+1))
  endif
  return indent(prevnonblank(v:lnum-1))
endfunction

" vim:set sts=2 sw=2:


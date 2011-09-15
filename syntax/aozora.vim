" ============================================================================
" Language:     青空文庫
" File:         syntax/aozora.vim
" Author:       mojako <moja.ojj@gmail.com>
" URL:          https://github.com/mojako/aozora.vim
" Last Change:  2011-09-14
" ============================================================================

" s:cpo_save {{{1
let s:cpo_save = &cpo
set cpo&vim
"}}}

if version < 600
    syntax clear
elseif exists('b:current_syntax')
    finish
endif

" 外字・特殊文字 {{{1
" ==============
syn match   aozoraGaiji     '※\ze［＃'

" アクセント符号付きアルファベット
syn match   aozoraAccented  "[AEIOUaeiou][`'^:_]\|[Aa][~&]\|[Oo][~/]"
syn match   aozoraAccented  "AE&\|ae&\|OE&\|oe&\|[Cc],\|[Nn]\~\|[Yy]'\|s&"

" ルビ {{{1
" ====
syn cluster aozoraRuby contains=aozoraRubyBase,aozoraRubyText

syn region  aozoraRubyBase matchgroup=aozoraSpecialChar start='｜' end='《\@='
syn region  aozoraRubyText matchgroup=aozoraSpecialChar start='《' end='》'

" 入力者注 {{{1
" ========
syn region  aozoraAnnotation start='［＃' end='］'

" 返り点・訓点送り仮名 {{{2
" --------------------
syn match   aozoraKaeriTen containedin=aozoraAnnotation
  \ '［＃\zs[一二三四上中下甲乙丙丁天地人レ]レ\?\ze］'
syn match   aozoraKuntenOkuri containedin=aozoraAnnotation
  \ '［＃（\zs.\{-}\ze）］'

" 左右中央 {{{1
" ========
syn region  aozoraCentering matchgroup=aozoraCentering
  \ start='^［＃ページの左右中央］\n\{3}'
  \ end='^\n\{2}\%(［＃改\%(丁\|ページ\)］$\)\@=' contains=ALL

" 改ページ {{{1
" ========
syn match   aozoraPageBreak     '^［＃改\%(丁\|ページ\|段\)］$'

" 注記記法 {{{1
" ========
syn match   aozoraMidashi   '［＃「.\{-}」は\%(同行\|窓\)\?[大中小]見出し］'

syn match   aozoraStyle
  \ '［＃「.\{-}」\%(の左\)\?に\%(\%(白ゴマ\|白\?丸\|[白黒]三角\|二重丸\|蛇の目\)\?傍点\|\%(傍線\|二重傍線\|鎖線\|破線\|波線\)\)］'
syn match   aozoraStyle
  \ '［＃「.\{-}」は\%(太字\|斜体\|縦中横\|行[左右]小書き\|[上下]付き小文字\|罫囲み\|横組み\|[０-９]\+段階\%(大き\|小さ\)な文字\)］'

" インライン記法 {{{1
" ==============
syn region  aozoraBlock oneline matchgroup=aozoraIndent
  \ start='^［＃[０-９]\+字下げ］'
  \ start='［＃\%(地付き\|地から[０-９]\+字上げ\)］' end='$'
  \ contains=ALL

syn region  aozoraBlock keepend oneline matchgroup=aozoraMidashi
  \ start='［＃\z(\%(同行\|窓\)\?[大中小]見出し\)］' end='［＃\z1終わり］'
  \ contains=ALL

syn region  aozoraBlock keepend oneline matchgroup=aozoraStyle
  \ start='［＃\z(\%(左に\)\?\%(\%(白ゴマ\|白\?丸\|[白黒]三角\|二重丸\|蛇の目\)\?傍点\|\%(傍線\|二重傍線\|鎖線\|破線\|波線\)\)\)］'
  \ start='［＃\z(太字\|斜体\|縦中横\|割り注\|行[左右]小書き\|[上下]付き小文字\|罫囲み\|横組み\)］'
  \ start='［＃[０-９]\+段階\z(大きな文字\|小さな文字\)］'
  \ end='［＃\z1終わり］' contains=ALL

" ブロック記法 {{{1
" ============
syn region  aozoraBlock keepend matchgroup=aozoraIndent
  \ start='^［＃ここから\%(\%(改行天付き\|[０-９]\+字下げ\)、折り返して\)\?[０-９]\+\z(字下げ\)］$'
  \ start='^［＃ここから\z(地付き\)］$'
  \ start='^［＃ここから地から[０-９]\+\z(字上げ\)］$'
  \ end='^［＃ここで\z1終わり］$' contains=ALL

syn region  aozoraBlock keepend matchgroup=aozoraMidashi
  \ start='^［＃ここから\z(\%(同行\|窓\)\?[大中小]見出し\)］$'
  \ end='^［＃ここで\z1終わり］$' contains=ALL

syn region  aozoraBlock keepend matchgroup=aozoraStyle
  \ start='^［＃ここから\z(太字\|斜体\|罫囲み\|横組み\)］$'
  \ start='^［＃ここから[０-９]\+\z(字詰め\)］$'
  \ start='^［＃ここから[０-９]\+段階\z(大きな文字\|小さな文字\)］$'
  \ end='^［＃ここで\z1終わり］$' contains=ALL

" 本文終わり {{{1
" ==========
syn region  aozoraAfterText start='^底本：' start='^［＃本文終わり］$'
  \ skip='.' end='.'
"}}}1

" Highlight Group Link {{{1
if v:version >= 508 || !exists('did_aozora_syn_inits')
    if v:version < 508
        let did_aozora_syn_inits = 1
        command -nargs=+ HiLink hi link <args>
    else
        command -nargs=+ HiLink hi def link <args>
    endif

    HiLink  aozoraGaiji         Special
    HiLink  aozoraAccented      Special

    HiLink  aozoraRubyBase      Normal
    HiLink  aozoraRubyText      Comment

    HiLink  aozoraAnnotation    Comment
    HiLink  aozoraBlock         Statement

    HiLink  aozoraKaeriTen      Normal
    HiLink  aozoraKuntenOkuri   Normal

    HiLink  aozoraPageBreak     PreProc
    HiLink  aozoraCentering     Type

    HiLink  aozoraIndent        Constant
    HiLink  aozoraMidashi       Identifier
    HiLink  aozoraStyle         Type

    HiLink  aozoraSpecialChar   Comment

    HiLink  aozoraAfterText     Constant

    delcommand HiLink
endif
"}}}1

let b:current_syntax = 'aozora'

" s:cpo_save {{{1
let &cpo = s:cpo_save
unlet s:cpo_save
"}}}

" vim: set et sts=4 sw=4 wrap:

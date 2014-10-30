"方向鍵不要ABCD
set nocompatible
set backspace=2
syntax on
inoremap ;; <Esc>
noremap zz <C-w>
nnoremap <silent> <F5> :NERDTree<CR>
nmap <F8> :TagbarToggle<CR>
"inoremap <space><space> <C-n>
"將Esc鍵替換為;;

set autoindent
set autowrite
set nu

set expandtab "use space instead of tab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set ru
set cursorline!
set hlsearch
set incsearch
set t_Co=256

"folding zi:start/stop zo(zO):open zc(zC):close zx:closeAllUnlessNow
set foldenable 
set foldmethod=syntax 
set foldcolumn=3 
nnoremap @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')

"$$$$$
set listchars=eol:$,tab:>.,trail:~,extends:>,precedes:<
set list
"statusline
set laststatus=2
set statusline=%4*%<\ %1*[%F]
set statusline+=%4*\ %5*[%{&encoding}, " encoding
set statusline+=%{&fileformat}%{\"\".((exists(\"+bomb\")\ &&\ &bomb)?\",BOM\":\"\").\"\"}]%m
set statusline+=%4*%=\ %6*%y%4*\ %3*%l%4*,\ %3*%c%4*\ \<\ %2*%P%4*\ \>
highlight User1 ctermfg=red
highlight User2 term=underline cterm=underline ctermfg=green
highlight User3 term=underline cterm=underline ctermfg=yellow
highlight User4 term=underline cterm=underline ctermfg=white
highlight User5 ctermfg=cyan
highlight User6 ctermfg=white

"plug-in
let iCanHazVundle=1
let vundle_readme=expand('~/.vim/bundle/vundle/README.md')
if !filereadable(vundle_readme)
	echo "Installing Vundle.."
	echo ""
	silent !mkdir -p ~/.vim/bundle
	silent !git clone https://github.com/gmarik/vundle ~/.vim/bundle/vundle
	let iCanHazVundle=0
endif
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
" Let Vundle manage itself.
Bundle "gmarik/vundle"
" Plugins
Bundle "MarcWeber/vim-addon-mw-utils"
Bundle "tomtom/tlib_vim"
Bundle "garbas/vim-snipmate"
Bundle "honza/vim-snippets"
Bundle "The-NERD-tree"
Bundle "Tagbar"
Bundle "AutoComplPop"
Bundle "Auto-Pairs"
Bundle "Syntastic"
Bundle "javacomplete"
setlocal omnifunc=javacomplete#Complete
autocmd FileType java inoremap <buffer> . .<C-X><C-O><C-P>

"colorscheme wombat256
if exists("syntax_on")
syntax reset
endif

let colors_name = "wombat256"


" General colors
hi Normal		ctermfg=254		ctermbg=234		cterm=none		guifg=#f6f3e8	guibg=#242424	gui=none
hi Cursor		ctermfg=none	ctermbg=241		cterm=none		guifg=NONE		guibg=#656565	gui=none
hi Visual		ctermfg=7		ctermbg=238		cterm=none		guifg=#f6f3e8	guibg=#444444	gui=none
" hi VisualNOS
" hi Search
hi Folded		ctermfg=103		ctermbg=238		cterm=none		guifg=#a0a8b0	guibg=#384048	gui=none
hi Title		ctermfg=7		ctermbg=none	cterm=bold		guifg=#f6f3e8	guibg=NONE		gui=bold
hi StatusLine	ctermfg=7		ctermbg=238		cterm=none		guifg=#f6f3e8	guibg=#444444	gui=italic
hi VertSplit	ctermfg=238		ctermbg=238		cterm=none		guifg=#444444	guibg=#444444	gui=none
hi StatusLineNC	ctermfg=243		ctermbg=238		cterm=none		guifg=#857b6f	guibg=#444444	gui=none
hi LineNr		ctermfg=243		ctermbg=0		cterm=none		guifg=#857b6f	guibg=#000000	gui=none
hi SpecialKey	ctermfg=244		ctermbg=236		cterm=none		guifg=#808080	guibg=#343434	gui=none
hi NonText		ctermfg=244		ctermbg=236		cterm=none		guifg=#808080	guibg=#303030	gui=none

" Vim >= 7.0 specific colors
if version >= 700
hi CursorLine					ctermbg=236		cterm=none						guibg=#2d2d2d
hi MatchParen	ctermfg=7		ctermbg=243		cterm=bold		guifg=#f6f3e8	guibg=#857b6f	gui=bold
hi Pmenu		ctermfg=7		ctermbg=238						guifg=#f6f3e8	guibg=#444444
hi PmenuSel		ctermfg=0		ctermbg=192						guifg=#000000	guibg=#cae682
endif


" Syntax highlighting
hi Keyword		ctermfg=111		cterm=none		guifg=#8ac6f2	gui=none
hi Statement	ctermfg=111		cterm=none		guifg=#8ac6f2	gui=none
hi Constant		ctermfg=173		cterm=none		guifg=#e5786d	gui=none
hi Number		ctermfg=173		cterm=none		guifg=#e5786d	gui=none
hi PreProc		ctermfg=173		cterm=none		guifg=#e5786d	gui=none
hi Function		ctermfg=192		cterm=none		guifg=#cae682	gui=none
hi Identifier	ctermfg=192		cterm=none		guifg=#cae682	gui=none
hi Type			ctermfg=192		cterm=none		guifg=#cae682	gui=none
hi Special		ctermfg=194		cterm=none		guifg=#e7f6da	gui=none
hi String		ctermfg=113		cterm=none		guifg=#95e454	gui=italic
hi Comment		ctermfg=246		cterm=none		guifg=#99968b	gui=italic
hi Todo			ctermfg=245		cterm=none		guifg=#8f8f8f	gui=italic


" Links
hi! link FoldColumn		Folded
hi! link CursorColumn	CursorLine

" vim:set ts=4 sw=4 noet:


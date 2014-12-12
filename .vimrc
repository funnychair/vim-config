syntax on
set nocompatible
set backspace=2
set expandtab "use space instead of tab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set nu
set ru
set cursorline!
set hlsearch
set incsearch

"Key map.
inoremap ;; <Esc>
noremap zz <C-w>
let mapleader = ","
"nnoremap j <Left>
"nnoremap k <Down>
"nnoremap i <Up>
"nnoremap l <Right>

"expr behavier
set completeopt=longest,menu
autocmd InsertLeave * if pumvisible() == 0|pclose|endif
inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"

"set end of line $
set listchars=eol:$,tab:>.,trail:~,extends:>,precedes:<
set list

"plug-in
"auto install vundle
let iCanHazVundle=1
let vundle_readme=expand('~/.vim/bundle/vundle/README.md')
if !filereadable(vundle_readme)
	echo "Installing Vundle.."
	echo ""
	silent !mkdir -p ~/.vim/bundle
	silent !git clone https://github.com/gmarik/vundle ~/.vim/bundle/vundle
	silent !sudo apt-get install exuberant-ctags
	let iCanHazVundle=0
endif

filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
" Let Vundle manage itself.
Plugin 'gmarik/vundle'
" Plugins

"YouCompleteMe
Bundle 'Valloric/YouCompleteMe'
Bundle 'Valloric/ListToggle'
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 0
let g:ycm_collect_identifiers_from_tag_files = 1
let g:ycm_min_num_of_chars_for_completion = 2
let g:ycm_cache_omnifunc = 0
let g:ycm_seed_identifiers_with_syntax = 1
nnoremap <F5> :YcmForceCompileAndDiagnostics<CR>
nnoremap <leader>jj :YcmCompleter GoToDefinitionElseDeclaration<CR>
",l & ,q faster windows of error and fix

"Syntastic
Bundle 'scrooloose/syntastic'
let g:syntastic_always_populate_loc_list = 1

"TagBar
Bundle 'majutsushi/tagbar'
let g:tagbar_autofocus = 1
let g:tagbar_width = 25
nmap <leader>tb :TagbarToggle<CR>  "打开tagbar窗口

"NERDTree
Bundle 'scrooloose/nerdtree'
nmap <leader>nt :NERDTree<CR>
let NERDTreeWinPos=0
let NERDTreeWinSize=25
let NERDTreeHighlightCursorline=1
let NERDTreeIgnore=[ '\.pyc$', '\.pyo$', '\.obj$', '\.o$', '\.so$', '\.egg$', '^\.git$', '^\.svn$', '^\.hg$' ]
let g:netrw_home='~/bak'
"close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") &&b:NERDTreeType == "primary") | q | end

"Open tagbar and nerdtree together for big screen.
nmap <leader>b\ :TagbarToggle<CR> :NERDTree<CR>

"Airline
Bundle 'bling/vim-airline'
let g:airline#extensions#tabline#enabled = 1
"let g:airline_powerline_fonts = 1
let g:airline_left_sep = ''
let g:airline_right_sep = ''


"indent line
Bundle 'nathanaelkane/vim-indent-guides'
let g:indent_guides_enable_on_vim_startup = 1  "defual open
let g:indent_guides_guide_size            = 2  " 指定对齐线的尺寸
let g:indent_guides_start_level       = 2  " 从第二层开始可视化显示缩进
" ,ig 打开/关闭 vim-indent-guides
"nnoremap <leader>bn :bn<CR>
"nnoremap <leader>bp :bp<CR>
nnoremap zx<Right> :bn<CR>
nnoremap zx<Left> :bp<CR>
nnoremap zx<Up> :bp<CR>:bd #<CR>



"colorsheme
Bundle 'altercation/vim-colors-solarized'
let g:solarized_termcolors=256
let g:solarized_termtrans=1
let g:solarized_contrast="normal"
let g:solarized_visibility="normal"
"" 主题 molokai
Bundle 'tomasr/molokai'
let g:molokai_original = 1
" 配色方案
set background=dark
set t_Co=256
"colorscheme solarized
colorscheme molokai
"colorscheme phd

filetype plugin indent on







"Set the IDE for small screen.
function! ToggleNERDTreeAndTagbar() 
    let w:jumpbacktohere = 1
    " Detect which plugins are open
    if exists('t:NERDTreeBufName')
        let nerdtree_open = bufwinnr(t:NERDTreeBufName) != -1
    else
        let nerdtree_open = 0
    endif
    let tagbar_open = bufwinnr('__Tagbar__') != -1
    " Perform the appropriate action
    if nerdtree_open && tagbar_open
        NERDTreeClose
        TagbarClose
    elseif nerdtree_open
        TagbarOpen
        wincmd K
        wincmd j
        wincmd l
        wincmd L
        wincmd h
        vertical resize 25
    elseif tagbar_open
        NERDTree
        wincmd l
        wincmd l
        wincmd K
        wincmd j
        wincmd l
        wincmd L
        wincmd h
        vertical resize 25
    else
        TagbarOpen
        NERDTree
        wincmd l
        wincmd l
        wincmd K
        wincmd j
        wincmd l
        wincmd L
        wincmd h
        vertical resize 25
    endif
    "Jump back to the original window
    for window in range(1, winnr('$'))
        execute window . 'wincmd w'
        if exists('w:jumpbacktohere')
            unlet w:jumpbacktohere
            break
            endif
    endfor  
endfunction
nnoremap <leader>\ :call ToggleNERDTreeAndTagbar()<CR>

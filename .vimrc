syntax on
set autoindent
set noexpandtab
set tabstop=4
set shiftwidth=4

set nu
set ru
set cursorline
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
nnoremap zx<Right> :bn<CR>
nnoremap zx<Left> :bp<CR>
nnoremap zx<Up> :bp<CR>:bd #<CR>

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

if has('nvim')
    " Neovim specific commands
else
    " Standard vim specific commands
endif

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


"TagBar
Bundle 'majutsushi/tagbar'
let g:tagbar_autofocus = 1
let g:tagbar_width = 25
nmap <leader>tb :TagbarToggle<CR>  "打开tagbar窗口



"Airline
Bundle 'bling/vim-airline'
let g:airline#extensions#tabline#enabled = 1
"let g:airline_powerline_fonts = 1
let g:airline_left_sep = ''
let g:airline_right_sep = ''


Bundle 'w0rp/ale'
let g:ale_sign_error = ''
let g:ale_sign_warning = ''
let g:ale_completion_enabled = 1
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_swift_swiftlint_use_defaults = 1
let g:ale_open_list = 0
let g:ale_lint_delay = 1000
let g:ale_linters = {
      \ 'go': ['gofmt'],
      \ }

set t_Co=256
Bundle "pR0Ps/molokai-dark"
Bundle "tomasr/molokai"
"let g:molokai_original = 1
"set background=dark
colorscheme molokai
"colorscheme molokai-dark


"Bundle 'fatih/vim-go',{'for':'go', 'do': ':GoUpdateBinaries'}
"let g:go_metalinter_command = "golangci-lint"
"let g:go_metalinter_enabled = ['vet', 'errcheck', 'staticcheck', 'gosimple']
"
"if has('nvim')
"  Bundle 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"else
"  Bundle 'Shougo/deoplete.nvim'
"  Bundle 'roxma/nvim-yarp'
"  Bundle 'roxma/vim-hug-neovim-rpc'
"endif
""let g:deoplete#enable_at_startup = 1
"inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
"inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
"inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"


"Bundle 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"Bundle 'zchee/deoplete-go', { 'do': 'make'}
"let g:deoplete#sources#go#gocode_binary = $GOPATH.'/bin/gocode'
"let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']






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
        vertical resize 35
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

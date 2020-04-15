syntax on
filetype plugin indent on

set encoding=utf-8

set guifont=Hack\ 9

set backspace=2
set synmaxcol=500
set number
set nowrap
set linebreak
set incsearch
set hlsearch
set ignorecase
set smartcase
set splitbelow
set splitright
set switchbuf=usetab
set hidden
set nocompatible
set scrolloff=8
set sidescroll=1
set sidescrolloff=15
set wildchar=<Tab> wildmenu wildmode=full

set foldenable
set foldlevelstart=10
set foldnestmax=10
set foldmethod=indent

set autoindent
set nosmartindent
set tabstop=4
set softtabstop=4
set shiftwidth=4

set autoread
set swapfile
set undofile
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//


" MAPPINGS

nnoremap <space> <nop>
let mapleader = " "

nmap <silent> <leader>b :NERDTreeToggle<CR> <C-W>=
nmap <silent> <leader>t :TagbarToggle<CR> <C-W>=
nmap <silent> <leader>g :YcmCompleter GoTo<CR>
nmap <silent> <leader>d :YcmCompleter GetDoc<CR>
nmap <silent> <leader>q <Plug>(qf_qf_toggle)
nmap <silent> <leader>n <Plug>(signify-next-hunk)
nmap <silent> <leader>p <Plug>(signify-prev-hunk)
nmap <silent> <leader>N 9999<Plug>(signify-next-hunk)
nmap <silent> <leader>P 9999<Plug>(signify-prev-hunk)
nmap <silent> <leader>u :UndotreeToggle<CR>
nmap <silent> <Leader>m <Plug>(git-messenger)
nmap <silent> <Leader>s :<C-u>call gitblame#echo()<CR>

nmap <silent> 0 <Plug>(ale_previous_wrap)
nmap <silent> + <Plug>(ale_next_wrap)

nnoremap <silent> <BS> :noh<CR>
inoremap jk <esc>

nnoremap j gj
nnoremap k gk

noremap <silent> <C-H> :wincmd h<CR>
noremap <silent> <C-J> :wincmd j<CR>
noremap <silent> <C-K> :wincmd k<CR>
noremap <silent> <C-L> :wincmd l<CR>

nnoremap <C-P> gT
nnoremap <C-N> gt

nnoremap gc :bp\|bd #<CR>

nnoremap <silent> <C-S> :wa<CR>
nnoremap <silent> <C-M> :wa<CR>

map <silent> å <C-]>
map ä <C-^>

noremap <left> 12zh
noremap <right> 12zl
noremap <up> 6<C-y>
noremap <down> 6<C-e>

nmap <F8> <Plug>(ale_fix)

nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)
" command! -nargs=+ -complete=file Ag Grepper -noprompt -tool ag -query <args>

nunmap <CR>


" DIFF MODE

if &diff
    set columns=250
    set lines=85
	autocmd VimResized * wincmd =
endif


" Python/Django

autocmd FileType python set ft=python.django
autocmd Filetype html set ft=htmldjango


" Statusline

set statusline=
set statusline+=%#LineNr#
set statusline+=%#CursorColumn#
set statusline+=\ %f
set statusline+=%m
set statusline+=%=
set statusline+=\ %y
set statusline+=\ %p%%
set statusline+=\ %l:%c
set statusline+=\


" PLUGINS

if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
				\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'dense-analysis/ale'
Plug 'jiangmiao/auto-pairs'
Plug 'nightsense/carbonized'
Plug 'metakirby5/codi.vim'
Plug 'mattn/emmet-vim'
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'}
Plug 'junegunn/fzf.vim'
Plug 'zivyangll/git-blame.vim'
Plug 'rhysd/git-messenger.vim'
Plug 'junegunn/goyo.vim'
Plug 'scrooloose/nerdtree'
Plug 'StanAngeloff/php.vim'
Plug '2072/PHP-Indenting-for-VIm'
Plug 'vim-python/python-syntax'
Plug 'majutsushi/tagbar'
Plug 'SirVer/ultisnips'
Plug 'mbbill/undotree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'gioele/vim-autoswap'
Plug 'qpkorr/vim-bufkill'
Plug 'easymotion/vim-easymotion'
Plug 'dag/vim-fish'
Plug 'mhinz/vim-grepper'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'sickill/vim-pasta'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'romainl/vim-qf'
Plug 'mhinz/vim-signify'
Plug 'lifepillar/vim-solarized8'
Plug 'tpope/vim-surround'
Plug 'ycm-core/YouCompleteMe', {'do': 'python3 install.py'}

call plug#end()


" GUI

if has("gui_running")
	colorscheme solarized8
	set background=light

	set guioptions-=T
	set guioptions-=m
	set guioptions-=r
	set guioptions-=L

	autocmd VimEnter * IndentGuidesEnable
else
	autocmd VimEnter * IndentGuidesDisable
endif


" ALE
let g:ale_linters = {"python": ["flake8"], "javascript": ["eslint", "flow-language-server"]}
let g:ale_fixers = {"*": ["remove_trailing_lines", "trim_whitespace"], "python": ["isort", "remove_trailing_lines", "trim_whitespace"]}
let g:ale_fix_on_save = 1


" codi.vim

" Python rephrasers
function! s:rp_py(buf)
	let b = a:buf
	" Insert # in the blank lines above Python's indention line to avoid
	" `IndentationError`.
	let b = substitute(b, '\(\s*\n\)\+\(\n\s\+\w\+\)\@=', '\=substitute(submatch(0), "\s*\n", "\r#", "g")', 'g')
	return b
endfunction

let g:codi#interpreters = {
	\ 'python.django': {
		\ 'bin': ['env', 'PYTHONSTARTUP=', 'python', 'manage.py', 'shell'],
		\ 'prompt': '^\(>>>\|\.\.\.\) ',
		\ 'rephrase': function('s:rp_py'),
	\ },
\ }
let g:codi#log = "/tmp/codi.log"


" completor.vim
let g:completor_python_binary = "/usr/bin/python3"


" ctrlspace
" set nocompatible
" set hidden
" if executable("ag")
    " let g:CtrlSpaceGlobCommand = 'ag --nocolor -g "" -f'
" endif
" let g:CtrlSpaceLoadLastWorkspaceOnStart = 0
" let g:CtrlSpaceSaveWorkspaceOnSwitch = 1
" let g:CtrlSpaceSaveWorkspaceOnExit = 1
" let g:CtrlSpaceStatuslineFunction = "airline#extensions#ctrlspace#statusline()"


" delimitMate
let g:delimitMate_expand_cr = 1
let g:delimitMate_expand_inside_quotes = 1


" Easymotion
map - <Plug>(easymotion-prefix)


" emmet-vim
nnoremap <C-Z> <nop>
let g:user_emmet_leader_key = "<C-Z>"


" fzf.vim
let g:fzf_layout = {'down': '~30%'}

function FzfAg(query)
    let query = empty(a:query) ? '^(?=.)' : a:query
    return call('fzf#vim#grep', ["ag --nogroup --column --nocolor " .  shellescape(query), 1, {"options": "--color light"}])
endfunction

let sitepackages_dir = system("python -c 'import sys; from distutils.sysconfig import get_python_lib; sys.stdout.write(get_python_lib())'")

" nmap <silent> <c-space> :call fzf#run(fzf#wrap("ag-files", {"source": "ag --nocolor -g '' -f", "options": "--color light"}))<cr>
" nmap <silent> <leader>f :call fzf#run(fzf#wrap("ag-sitepackages", {"source": "ag --nocolor -g '' -f -p ~/.config/spignore", "options": "--color light", "dir": sitepackages_dir}))<cr>
nmap <silent> <c-space> :call fzf#run(fzf#wrap("rg-files", {"source": "rg --color=never --files", "options": "--color light"}))<cr>
nmap <silent> <leader>f :call fzf#run(fzf#wrap("rg-sitepackages", {"source": "rg --files --color=never --ignore-file ~/.config/spignore", "options": "--color light", "dir": sitepackages_dir}))<cr>
nmap <silent> <leader>a :Ag<cr>
command! -nargs=? Ag call FzfAg(<q-args>)

" nmap <silent> <leader>a :call fzf#run(fzf#wrap("ag-content", {"source": "ag --nocolor -f", "options": "--color light"}))<cr>


" grepper
let g:grepper = {}
let g:grepper.highlight = 1
let g:grepper.simple_prompt = 1
let g:grepper.tools = ['rg', 'ag', 'grep']


" indent-guides
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_color_change_percent = 3
let g:indent_guides_exclude_filetypes = ['help', 'nerdtree']


" NERDTree
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let NERDTreeQuitOnOpen = 1
let NERDTreeMinimalUI = 1


" Python syntax
let g:python_highlight_class_vars = 0
let g:python_highlight_all = 1


" Signify
let g:signify_vcs_list = ["git", "svn"]


" tagbar
let g:tagbar_autoclose = 1
let g:tagbar_autofocus = 1
let g:tagbar_zoomwidth = 70
let g:tagbar_compact = 1
let g:tagbar_sort = 1


" Undotree
let g:undotree_SetFocusWhenToggle = 1

" Vim-Airline
set laststatus=2
set showtabline=0
let g:airline_theme = "solarized"
let g:airline_extensions = ['hunks', 'tagbar', 'ale', 'quickfix']
let g:airline_powerline_fonts = 1
let g:airline_skip_empty_sections = 1
let g:airline#extensions#hunks#non_zero_only = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#show_tab_nr = 0
let g:airline#extensions#tabline#show_close_button = 0

function! AirlineInit()
    let spc = g:airline_symbols.space
    let g:airline_section_x = airline#section#create_right(['tagbar'])
    let g:airline_section_y = airline#section#create_right(['filetype'])
    let g:airline_section_z = airline#section#create(['%3p%%', spc, '%l:%v'])
endfunction
autocmd User AirlineAfterInit call AirlineInit()


" vim-qf
let g:qf_auto_resize = 0
let g:qf_max_height = 30


" vim-javascript
let g:javascript_plugin_flow = 1


" UltiSnips
let g:UltiSnipsUsePythonVersion = 3


" YouCompleteMe
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_key_list_select_completion = ['<Down>']
let g:ycm_key_list_previous_completion = ['<Up>']
let g:ycm_key_detailed_diagnostics = ''

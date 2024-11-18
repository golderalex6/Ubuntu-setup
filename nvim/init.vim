call plug#begin('~/.config/nvim/Plugins')

Plug 'catppuccin/nvim', { 'as': 'catppuccin' } 		"Theme

"File browser
Plug 'preservim/nerdtree'		"Main
Plug 'ryanoasis/vim-devicons'	"Icon
Plug 'Xuyuanp/nerdtree-git-plugin'	"Git status
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'	"Syntax highlight
Plug 'PhilRunninger/nerdtree-buffer-ops'	"Display open buffer

"Status Bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

"Terminal
Plug 'voldikss/vim-floaterm'

"Python Autocomplete
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'deoplete-plugins/deoplete-jedi'


Plug 'Townk/vim-autoclose' " Automatically close parenthesis, etc

Plug 'neomake/neomake' "To add pylint as a plugin

Plug 'f-person/git-blame.nvim' "Git checking

Plug 'Pocco81/auto-save.nvim' "Autosave

Plug 'farmergreg/vim-lastplace' "Continue where you left off

"HTML autocomplete 
Plug 'mattn/emmet-vim'
Plug 'alvan/vim-closetag'

Plug 'jiangmiao/auto-pairs' "Auto indent after space for parenthesis

Plug 'tpope/vim-commentary' "For comment multiple line

"fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

"Text finder
Plug 'rking/ag.vim'

"Repl in vim
Plug 'tpope/vim-repeat'
Plug 'pappasam/nvim-repl'

"Indentation line
Plug 'Yggdroot/indentLine'

"parenthese surround
Plug 'tpope/vim-surround'

"Close html tags
Plug 'alvan/vim-closetag'
call plug#end()

colorscheme catppuccin " catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
set number
set smartindent
set tabstop=4
set shiftwidth=4
set shiftround
set virtualedit+=onemore

nnoremap <silent> <F2> :bprevious <CR>	"Move to next buffer
nnoremap <silent> <F3> :bnext <CR>	"Move to previous buffer
nnoremap <silent> <F4> :bw<CR>	"remove buffer
"NERDTREE
let NERDTreeShowHidden=1
nnoremap <silent><F1> :NERDTreeRefreshRoot<CR>	"Refresh NerdTree
nnoremap <silent> <F5> :NERDTreeToggle<CR>	"Open NerdTree
nnoremap <silent> <F6> :NERDTreeFocus<CR>	"Close NerdTree
" Exit Vim if NERDTree is the only window remaining in the only tab.
"autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

let g:NERDTreeDirArrowExpandable = '▶'
let g:NERDTreeDirArrowCollapsible = '▼'

"Floaterm
"Run the current python file
"nnoremap <silent> <F7> :FloatermNew --autoclose=0 source /py_virtual/bin/activate  && python3 %<CR>
"Run the current bash file
autocmd FileType python nnoremap <buffer> <silent> <F7> :FloatermNew --autoclose=0 source /py_virtual/bin/activate  && python3 %<CR>
autocmd FileType sh nnoremap <buffer> <silent> <F7> :FloatermNew --autoclose=0 chmod 700 % && source % <CR> 
let g:floaterm_keymap_new ='<F8>'	"Create new terminal
let g:floaterm_keymap_kill   = '<F9>'	"Close current terminal
"let g:floaterm_keymap_next   = '<F10>'
"let g:floaterm_keymap_toggle = '<F12>'

"Vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:python3_host_prog='/py_virtual/bin/python3'
"Deoplete Vim 
let g:deoplete#enable_at_startup = 1
call deoplete#custom#option("max_list",10)

"Neomake
call neomake#configure#automake('nrw', 50)
let g:neomake_python_enabled_makers = ['pylint']

"nvim-repl
let g:repl_split = 'right'
autocmd FileType python nnoremap <buffer> <silent> <leader>rt :ReplToggle<CR>
autocmd FileType python nnoremap <buffer> <silent> <leader>rc :ReplRunCell<CR>
autocmd FileType python nnoremap <buffer> <silent> <leader>re <Plug>ReplSendLine
autocmd FileType python vnoremap <buffer> <silent> <leader>re <Plug>ReplSendVisual

"indentLine
let g:indentLine_concealcursor = 'inc'
let g:indentLine_conceallevel = 2

"surround
autocmd FileType html,markdown,python set omnifunc=htmlcomplete#CompleteTags

"close tags
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.md,*py'

"snippet for auto create notebook block
iabbrev @# #%%<CR><CR>#%%<ESC>k


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

Plug 'neovim/nvim-lspconfig'  " Language Server Protocol
Plug 'hrsh7th/nvim-cmp'       " Completion engine
Plug 'hrsh7th/cmp-nvim-lsp'   " LSP completion source
Plug 'saadparwaiz1/cmp_luasnip' " Snippets
Plug 'L3MON4D3/LuaSnip'       " Snippets engine

"code highlight
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

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

"Markdown preview
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

"Custom code snippets
Plug 'SirVer/ultisnips'


"Multi db DBMS
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'

call plug#end()


set number
set smartindent
set tabstop=4
set shiftwidth=4
set shiftround
set virtualedit+=onemore


nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <C-w>l <C-w>v
nnoremap <C-w>j <C-w>s

nnoremap <silent>  <C-Up>    :resize -3<CR>
nnoremap <silent>  <C-Down>  :resize +3<CR>
nnoremap <silent>  <C-Left>  :vertical resize -3<CR>
nnoremap <silent> <C-Right> :vertical resize +3<CR>


colorscheme catppuccin " catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha

"NERDTREE
let NERDTreeShowHidden=1
nnoremap <silent> <F2> :bprevious <CR>	"Move to next buffer
nnoremap <silent> <F3> :bnext <CR>	"Move to previous buffer
nnoremap <silent> <F4> :bw<CR>	"remove buffer
nnoremap <silent><F1> :NERDTreeRefreshRoot<CR>	"Refresh NerdTree
nnoremap <silent> <F5> :NERDTreeToggle<CR>	"Open NerdTree
nnoremap <silent> <F6> :NERDTreeFocus<CR>	"Close NerdTree
" Exit Vim if NERDTree is the only window remaining in the only tab.
"autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

let g:NERDTreeDirArrowExpandable = '▶'
let g:NERDTreeDirArrowCollapsible = '▼'

"Floaterm
"Run the current bash file
autocmd FileType python nnoremap <buffer> <silent> <F7> :FloatermNew --autoclose=0 source /py_virtual/bin/activate  && python3 %<CR>

"Run the current js file
autocmd FileType javascript nnoremap <buffer> <silent> <F7> :FloatermNew --autoclose=0 node %<CR>

"Run the current python file
autocmd FileType sh nnoremap <buffer> <silent> <F7> :FloatermNew --autoclose=0 chmod 700 % && source % <CR> 

let g:floaterm_keymap_new ='<F8>'	"Create new terminal
let g:floaterm_keymap_kill   = '<F9>'	"Close current terminal

"Vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:python3_host_prog=expand('/py_virtual/bin/python3')


"Neomake
call neomake#configure#automake('nrw', 50)
let g:neomake_python_enabled_makers = ['pylint'] "python
let g:neomake_python_pylint_maker = {
    \ 'exe': '/py_virtual/bin/pylint',
    \ 'args': ['--rcfile=.pylintrc'],
    \ 'errorformat':
    \ '%A%f:%l: [%t%n] %m,' .
    \ '%A%f:%l: %m,' .
    \ '%C%m,' .
    \ '%Z%m',
    \ }
let g:neomake_javascript_enabled_makers = ['jshint'] "js


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


" Configure LSP and Autocompletion
lua << EOF
	local lspconfig = require('lspconfig')
	local cmp = require('cmp')

	-- Python
	lspconfig.pyright.setup{}

	-- JavaScript and TypeScript via tsserver
	lspconfig.ts_ls.setup{}

	-- HTML
	lspconfig.html.setup{
		filetypes = {"html","htmldjango"}
	}

	-- CSS
	lspconfig.cssls.setup{}


	-- Bash
	lspconfig.bashls.setup{}

	-- mysql,sqlite3
	lspconfig.sqlls.setup{
		filetypes = { 'sql' },
		root_dir = function(_)
			return vim.loop.cwd()
		end,
	}

	--nginx.conf
	lspconfig.nginx_language_server.setup{}

	-- DockerFile
	lspconfig.dockerls.setup{}

	
	--go to the function code
	vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap=true, silent=true })

	-- in your init.lua or a Lua config file
	vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { 'docker-compose.yaml', 'docker-compose.yml', 'compose.yaml', 'compose.yml' }, -- match files by extension or filename
	callback = function()
		vim.bo.filetype = "yaml.docker-compose"
	end,
	})

	--Docker-compose
	lspconfig.docker_compose_language_service.setup{}


  -- Autocompletion setup
  cmp.setup({
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    mapping = {},
	sources = {
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
    },

  })
EOF


" catppuccin trasnparent
lua << EOF
require('catppuccin').setup({
    transparent_background = true, -- Enable transparency
    integrations = {
        treesitter = true, -- Enable Treesitter integration
        lsp_trouble = true, -- Enable LSP Trouble integration
    },
})
vim.cmd.colorscheme 'catppuccin'
EOF

"Function definition
autocmd FileType python nnoremap <buffer> <silent>fd :lua vim.lsp.buf.hover()<CR>
autocmd FileType javascript nnoremap <buffer> <silent>fd :lua vim.lsp.buf.hover()<CR>

"Trailing space
inoremap <expr> = getline('.')[col('.')-1] == '=' ? '=' : ' = '
nnoremap =  i == 
inoremap -> <Space>-><Space>

" Ultisnip
" Use <Enter> to expand snippets and <C-j>/<C-k> to jump between placeholders
let g:UltiSnipsExpandTrigger="<Enter>"
let g:UltiSnipsJumpForwardTrigger="<C-j>"
let g:UltiSnipsJumpBackwardTrigger="<C-k>"

" Directory for custom snippets
let g:UltiSnipsSnippetDirectories=["UltiSnips"]


" Set line numbers to white
autocmd ColorScheme * highlight LineNr guifg=#FFFFFF
autocmd ColorScheme * highlight CursorLineNr guifg=#FFFFFF

" Markdown preview
" set to 1, nvim will open the preview window after entering the Markdown buffer
" default: 0
let g:mkdp_auto_start = 0
" set to 1, the nvim will auto close current preview window when changing
" from Markdown buffer to another buffer
" default: 1
let g:mkdp_auto_close = 0

"vim-dadbod
let g:db_ui_use_nerd_fonts = 1


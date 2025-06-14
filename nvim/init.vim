call plug#begin('~/.config/nvim/Plugins')

Plug 'catppuccin/nvim', { 'as': 'catppuccin' } 		"Theme

"Status Bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

"Terminal
Plug 'voldikss/vim-floaterm'

Plug 'neovim/nvim-lspconfig'  " Language Server Protocol
Plug 'folke/trouble.nvim'

Plug 'hrsh7th/nvim-cmp'       " Completion engine
Plug 'hrsh7th/cmp-nvim-lsp'   " LSP completion source
Plug 'saadparwaiz1/cmp_luasnip' " Snippets
Plug 'L3MON4D3/LuaSnip'       " Snippets engine

"code highlight
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'Townk/vim-autoclose' " Automatically close parenthesis, etc

Plug 'mfussenegger/nvim-lint' "linter

Plug 'f-person/git-blame.nvim' "Git checking

Plug 'Pocco81/auto-save.nvim' "Autosave

Plug 'farmergreg/vim-lastplace' "Continue where you left off

Plug 'lewis6991/hover.nvim' "nvim-hover

"HTML autocomplete 
Plug 'mattn/emmet-vim'
Plug 'alvan/vim-closetag'

Plug 'jiangmiao/auto-pairs' "Auto indent after space for parenthesis

Plug 'tpope/vim-commentary' "For comment multiple line


Plug 'David-Kunz/gen.nvim' "A.i model
"A.i model
Plug 'Kurama622/llm.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'MunifTanjim/nui.nvim'


"Text finder
Plug 'rking/ag.vim'

"Repl in vim
Plug 'tpope/vim-repeat'
Plug 'pappasam/nvim-repl'


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


"Start up
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-file-browser.nvim'
Plug 'startup-nvim/startup.nvim'

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

"remove left-margin
set fillchars=eob:\ 


"use for scroll up/down faster
nnoremap J 7j
nnoremap K 7k

colorscheme catppuccin " catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha

"NERDTREE
let NERDTreeShowHidden=1
nnoremap <silent> <F2> :bprevious <CR>	"Move to next buffer
nnoremap <silent> <F3> :bnext <CR>	"Move to previous buffer
nnoremap <silent> <F4> :bw<CR>	"remove buffer


"exit window
nnoremap <silent> <F1> :q<CR>

" Map F5 to Telescope find_files
nnoremap <silent> <F5> :Telescope file_browser<CR>

" Map F6 to Telescope live_grep
nnoremap <silent> <F6> :Telescope live_grep<CR>

"Map F8 to go to dadbod nvim
nnoremap <silent> <F8> :DBUI<CR>


let g:NERDTreeDirArrowExpandable = '▶'
let g:NERDTreeDirArrowCollapsible = '▼'


"Floaterm
"Run the current python file
autocmd FileType python nnoremap <buffer> <silent> <F7> :FloatermNew --autoclose=0 python3 %<CR>
"Run the current js file
autocmd FileType javascript nnoremap <buffer> <silent> <F7> :FloatermNew --autoclose=0 node %<CR>
"Run the current bash file
autocmd FileType sh nnoremap <buffer> <silent> <F7> :FloatermNew --autoclose=0 chmod 700 % && source % <CR> 
tnoremap <Esc> <C-\><C-n> :FloatermKill <CR>




"Vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:python3_host_prog=expand('/py_virtual/bin/python3')


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

	-- Ruff-Python
	lspconfig.pyright.setup{}
	local lint = require("lint")

	lint.linters_by_ft = {
		python = { "ruff" },
		javascript = { "eslint" },
		lua = { "luacheck" },
	}

	vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
	callback = function()
		lint.try_lint()
	end,
	})

	vim.diagnostic.config({
		virtual_text = true,
		signs = true,
		underline = true,
	})



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
    transparent_background = false, -- Enable transparency
    integrations = {
        treesitter = true, -- Enable Treesitter integration
        lsp_trouble = true, -- Enable LSP Trouble integration
    },
})
vim.cmd.colorscheme 'default'
EOF


"Function definition
autocmd FileType python nnoremap <buffer> <silent>fd :lua vim.lsp.buf.hover()<CR>
autocmd FileType javascript nnoremap <buffer> <silent>fd :lua vim.lsp.buf.hover()<CR>

autocmd FileType python nnoremap <buffer> <silent>gd :lua vim.lsp.buf.definition()<CR>
autocmd FileType javascript nnoremap <buffer> <silent>gd :lua vim.lsp.buf.definition()<CR>


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

lua << EOF
local fb_actions = require("telescope").extensions.file_browser.actions

require('telescope').setup({
  extensions = {
    file_browser = {
      hijack_netrw = true,
      grouped = true,
      hidden = { file_browser = true, folder_browser = true },
      no_ignore = true,
      depth = 1,
      mappings = {
        ["n"] = {
          ["c"] = fb_actions.create,
          ["r"] = fb_actions.rename,
          ["d"] = fb_actions.remove,
          ["m"] = fb_actions.move,
        },
      },
    },
  },
})

require('telescope').load_extension('file_browser')
EOF



lua << EOF
require("startup").setup({
    header = {
        type = "text",
        align = "center",
        fold_section = false,
        title = "Header",
        margin = 5,
        --content = require("startup.headers").hydra_header,
        content = {
    [[          ▀████▀▄▄              ▄█ ]],
    [[            █▀    ▀▀▄▄▄▄▄    ▄▄▀▀█ ]],
    [[    ▄        █          ▀▀▀▀▄  ▄▀  ]],
    [[   ▄▀ ▀▄      ▀▄              ▀▄▀  ]],
    [[  ▄▀    █     █▀   ▄█▀▄      ▄█    ]],
    [[  ▀▄     ▀▄  █     ▀██▀     ██▄█   ]],
    [[   ▀▄    ▄▀ █   ▄██▄   ▄  ▄  ▀▀ █  ]],
    [[    █  ▄▀  █    ▀██▀    ▀▀ ▀▀  ▄▀  ]],
    [[   █   █  █      ▄▄           ▄▀   ]],
},
		content = {
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⡋⠙⠳⠦⣄⣀⠀⠀⠀⠀⠀⠀⢀⢀⣀⣀⣀⣀⣀⣀⡀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡠⠤⠴⠶⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⡼⣿⣻⣴⣀⠈⠙⢶⣤⣠⡴⠶⠛⠉⢉⣉⠉⠁⠈⠉⠉⠉⠙⠛⠶⢤⣀⡀⢀⡤⠒⠉⠁⠀⠀⠀⢀⣬⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣷⢻⣽⢷⣻⣟⣦⠾⠉⠁⣠⣤⡶⠟⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣽⠟⠉⠀⠀⠀⠀⢀⣠⣴⣿⡻⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣎⢿⣻⣽⠞⠁⢠⣴⡿⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⡃⠀⠀⠀⣠⣤⣾⣟⣯⡷⡟⣹⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣮⡟⠁⢠⣼⡿⠏ ⠀ ⠀     _⠀⠀_   ⢹⣧⠀⣰⣾⢿⣽⡾⣽⣳⣿⣫⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀  ]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⠏⠀⣰⡿⣯⠃   |\\⠀| |_ | |⠀ ⠀⠻⣦⡹⣯⡿⣾⣽⢿⣽⡾⠃⠀⠀⠀⠀⠀⠀      ]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⠇⠀⣸⡿⣽⠃    | \\| |_ |_|⠀ ⠀⠀ ⠛⠶⣽⣓⣯⣿⢿⣅⠘⠀⠀⠀⠀⠀⠀  ⠀⠀ ⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⠀⣰⣿⣻⢿⠀            .       ⠀⠀⠀ ⢩⣭⡍⠀⢻⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⡇⠀⣾⢷⣻⣿⠀⣀⣀⣀⡀⠀  \  /⠀| |\\  /| ⠀⢀⣾⣯⢷⠀⢈⣇⠀⠀⠀⠀⠀⠀⠀⠀ ⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⢰⣯⣿⣻⣞⡿⣿⡽⣯⢿⡷⣦⣀⠀\/⠀⠀| | \\/ |⠀⢀⣼⣟⡾⣿⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⡀⠈⣿⣞⡷⣟⣿⣳⣿⣻⢯⣿⡽⣯⣧⡀            ⢀⣾⣽⢾⡿⣽⠂⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣇⠀⢹⣾⣟⣯⣷⢿⡾⣽⣟⡷⣿⢯⣷⢿⣤⠀⠀⠀⠀  ⠀⠀⠀⢀⣴⣿⣻⢾⣻⣽⠿⠀⢐⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡀⠈⢷⣯⣟⣾⢿⣽⣟⡾⣿⡽⣿⢾⣻⣽⣳⣄⡀⡀⠀⣀⣀⣤⡶⣟⡿⣾⡽⣟⣯⣟⠇⠀⣼⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢧⠀⠘⢟⣾⢯⣿⢾⣽⣻⢷⣟⣯⡿⣯⣷⢿⡽⣿⣻⣟⣯⢿⣞⣿⣻⣽⡷⣿⣻⣽⠎⠀⣰⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢧⡀⠈⢻⣯⣟⣯⣷⢿⣯⣟⡷⣿⣽⢾⣻⣟⡷⣿⣽⢾⡿⣽⡾⣯⡷⣿⣳⡿⠉⠀⣰⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣄⠀⠙⢾⣻⢾⣟⣾⣽⣻⢷⣯⣿⣻⢾⣟⣷⣯⢿⣻⣽⣻⢷⣟⡯⠗⠁⢠⡞⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠳⣄⡀⠉⠻⢾⣻⣞⣯⣿⣞⡷⣿⣻⡾⣷⣻⢿⣽⣳⡿⠯⠋⠀⣠⠶⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠳⠦⣄⡀⠈⠉⠓⠛⠾⠟⠷⠿⠽⠷⠟⠛⠉⠁⠀⣠⡴⠞⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠛⠶⡤⣤⣠⣤⣀⣀⣠⣤⡤⠤⠶⠞⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
		},
        highlight = "Statement",
        default_color = "",
        oldfiles_amount = 0,
    },
    header_2 = {
        type = "text",
        oldfiles_directory = false,
        align = "center",
        fold_section = false,
        title = "Quote",
        margin = 5,
        content = {"Extremely fast, lightweight as fuck, setup in under a minute !!","    --TranHongLoan/golderalex"},
        highlight = "Constant",
        default_color = "",
        oldfiles_amount = 0,
    },
    -- name which will be displayed and command
    body = {
        type = "mapping",
        oldfiles_directory = false,
        align = "center",
        fold_section = false,
        title = "Basic Commands",
        margin = 5,        content = {
            { " File Browser", "Telescope file_browser", "<leader>fb" },
            { " Database", "DBUI", "F8" },
            { " Find File", "Telescope find_files", "<leader>ff" },
            { " New File", "lua require'startup'.new_file()", "<leader>nf" },
            { "󰍉 Find Word", "Telescope live_grep", "<leader>lg" },
            { " Colorschemes", "Telescope colorscheme", "<leader>cs" },
        },
        highlight = "String",
        default_color = "",
        oldfiles_amount = 0,
    },

    clock = {
        type = "text",
        content = function()
            local clock = " " .. os.date("%H:%M")
            local date = " " .. os.date("%d-%m-%y")
            return { clock, date }
        end,
        oldfiles_directory = false,
        align = "center",
        fold_section = false,
        title = "",
        margin = 5,
        highlight = "TSString",
        default_color = "#FFFFFF",
        oldfiles_amount = 10,
    },

    footer_2 = {
        type = "text",
        content = require("startup.functions").packer_plugins(),
        oldfiles_directory = false,
        align = "center",
        fold_section = false,
        title = "",
        margin = 5,
        highlight = "TSString",
        default_color = "#FFFFFF",
        oldfiles_amount = 10,
    },

    options = {
        after = function()
            require("startup.utils").oldfiles_mappings()
        end,
        mapping_keys = true,
        cursor_column = 0.5,
        empty_lines_between_mappings = true,
        disable_statuslines = true,
        paddings = { 2, 2, 2, 2, 2, 2, 2 },
    },
    colors = {
        background = "#1f2227",
        folded_section = "#56b6c2",
    },
    parts = {
        "header",
        "header_2",
        "body",
        "clock",
        "footer_2",
    },
}
)
EOF

lua << EOF
-- Also unmap on FileType event to cover initial buffer load
vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
  callback = function()
    if vim.bo.filetype == "startup" then
	--Disable for prevent suddenly call when open
      pcall(vim.keymap.del, "n", "<F4>") 
      pcall(vim.keymap.del, "n", "<F5>") 
      pcall(vim.keymap.del, "n", "<F6>") 
    end
  end,
})

-- Restore on leaving buffer
vim.api.nvim_create_autocmd("BufLeave", {
  callback = function()
    vim.keymap.set("n", "<F4>", ":bw<CR>", { silent = true })
    vim.keymap.set("n", "<F5>", ":Telescope file_browser<CR>", { silent = true })
    vim.keymap.set("n", "<F6>", ":Telescope live_grep<CR>", { silent = true })
  end,
})
EOF


lua<<EOF
require("gen").setup {
  model = "llama3.2", -- Default model
  quit_map = "q", -- Close window keymap
  retry_map = "<c-r>", -- Retry keymap
  accept_map = "<c-cr>", -- Accept result keymap
  host = "localhost", -- Ollama host
  port = "11434", -- Ollama port
  display_mode = "float", -- Display mode
  show_prompt = false, -- Hide prompt
  show_model = false, -- Hide model name
  no_auto_close = false, -- Auto close
  file = false,
  hidden = false,
  init = function(options)
    pcall(io.popen, "ollama serve > /dev/null 2>&1 &")
  end,
  command = function(options)
    local body = { model = options.model, stream = true }
    return "curl --silent --no-buffer -X POST http://" .. options.host .. ":" .. options.port .. "/api/chat -d $body"
  end,
  result_filetype = "markdown",
  debug = false
}
EOF
noremap <silent> <F9> :Gen<CR>


lua<<EOF
local tools = require("llm.tools") -- Required for app_handler
local function local_llm_streaming_handler(chunk, ctx, F)
  if not chunk then
    return ctx.assistant_output
  end

  local tail = chunk:sub(-1, -1)
  if tail ~= "}" then
    ctx.line = ctx.line .. chunk
  else
    ctx.line = ctx.line .. chunk
    local status, data = pcall(vim.fn.json_decode, ctx.line)
    if not status or not data.message or not data.message.content then
      return ctx.assistant_output
    end
    ctx.assistant_output = ctx.assistant_output .. data.message.content
    F.WriteContent(ctx.bufnr, ctx.winid, data.message.content)
    ctx.line = ""
  end
  return ctx.assistant_output
end

local function local_llm_parse_handler(chunk)
  return chunk.message and chunk.message.content or ""
end

require("llm").setup({
  url = "http://localhost:11434/api/chat", -- Ollama's endpoint
  model = "mistral",-- Adjust based on your model
  streaming_handler = local_llm_streaming_handler,
  app_handler = {
    WordTranslate = {
      handler = tools.flexi_handler,
      prompt = "Translate the following text to Chinese, please only return the translation",
      opts = {
        parse_handler = local_llm_parse_handler,
        exit_on_move = true,
        enter_flexible_window = false,
      },
    },
  },
})

EOF
noremap <silent> <F9> :LLMSessionToggle<CR>


" Enable saving view settings like folds, cursor, window position, etc
augroup remember_view
  autocmd!
  autocmd BufWinLeave * silent! mkview
  autocmd BufWinEnter * silent! loadview
augroup END




lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = { enable = true },
  indent = { enable = true },
}
EOF

" Use expression-based folding
set foldmethod=manual
set foldexpr=nvim_treesitter#foldexpr()
set foldlevelstart=99
set foldenable



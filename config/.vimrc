call plug#begin()
	Plug 'https://github.com/joshdick/onedark.vim.git'
call plug#end()

if has('termguicolors')
	set termguicolors
endif

set background=dark

colorscheme onedark 

set clipboard=unnamedplus
set showcmd


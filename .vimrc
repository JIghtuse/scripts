set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

syntax enable
Bundle 'git://github.com/gmarik/vundle.git'
" Interface
Bundle 'git://github.com/altercation/vim-colors-solarized.git'
Bundle 'git://github.com/scrooloose/nerdtree.git'
Bundle 'git://github.com/scrooloose/nerdcommenter.git'
Bundle 'git://github.com/ervandew/supertab.git'
Bundle 'git://github.com/vim-scripts/taglist.vim.git'
" Python/Django
Bundle 'git://github.com/fs111/pydoc.vim.git'
" Perl
Bundle 'git://github.com/petdance/vim-perl.git'
Bundle 'git://github.com/ggray/vim-tt2.git'

filetype plugin indent on
set nonumber
set encoding=utf-8
set fileencodings=utf8,cp1251
set wildmode=list:longest,full
set wildmenu
set wildignore+=.hg,.git,.svn
set wildignore+=*.pyc
"set title
set showtabline=1
set showcmd
"set list
set wrap
if version >= 703
	set colorcolumn=80
end
set linebreak
set autoindent
set smartindent
set shiftwidth=4
set tabstop=4
set linespace=1
set scrolloff=2
set showcmd
set history=1000
set incsearch
set hlsearch
nmap <C-X> :noh<Enter>
vmap <C-X> :s/^\/\///<Enter>
vmap <C-C> :s/^/\/\//<Enter>
nmap <C-S> :.,/^$/-1!sort<Enter>
if has("gui_running")
	set go=
	set gfn=Ubuntu\ Mono\ 13
	"set gfn=Droid\ Sans\ Mono\ 11
	set background=light
	colorscheme solarized
	"let g:solarized_termcolors=256
else
	set background=light
	let g:solarized_termtrans=1
	let g:solarized_termcolors=256
	colorscheme solarized
endif
set iminsert=0
set imsearch=0
highlight lCursor guifg=NONE guibg=Cyan
map <F5> :wall \|make <Cr>
"noremap <Up> <NOP>
"noremap <Down> <NOP>
"noremap <Left> <NOP>
"noremap <Right> <NOP>
"inoremap <Up> <NOP>
"inoremap <Down> <NOP>
"inoremap <Left> <NOP>
"inoremap <Right> <NOP>
function! FileSize()
	let bytes = getfsize(expand("%:p"))
	if bytes <= 0
		return 
	endif
	if bytes < 1024
		return bytes . "B"
	else
		return (bytes / 1024) . "K"
	endif
endfunction

function! CurDir()
	let curdir = substitute(expand('%:p'), '/home/libreofficer', '~', 'g')
	return curdir
endfunction


set laststatus=2
set statusline=\
set statusline+=%n:\ " buffer number
set statusline+=%t " filename with full path
set statusline+=%m " modified flag
set statusline+=\ \
set statusline+=%{&paste?'[paste]\ ':''}
set statusline+=%{&fileencoding}
set statusline+=\ \ %Y " type of file
set statusline+=\ %3.3(%c%) " column number
set statusline+=\ \ %3.9(%l/%L%) " line / total lines
set statusline+=\ \ %2.3p%% " percentage through file in lines
set statusline+=\ \ %{FileSize()}
set statusline+=%< " where truncate if line too long
set statusline+=\ \ Dir:%{CurDir()}

if version >= 700
	set spell spelllang=
    set nospell " По умолчанию проверка орфографии выключена
    menu Spell.off :setlocal spell spelllang= <cr>
    menu Spell.Russian+English :setlocal spell spelllang=ru,en <cr>
    menu Spell.Russian :setlocal spell spelllang=ru <cr>
    menu Spell.English :setlocal spell spelllang=en <cr>
    menu Spell.-SpellControl- :
    menu Spell.Word\ Suggest<Tab>z= z=
    menu Spell.Previous\ Wrong\ Word<Tab>[s [s
    menu Spell.Next\ Wrong\ Word<Tab>]s ]s
endif

let loaded_matchparen=1
set noshowmatch
imap <C-h> <C-o>h
imap <C-j> <C-o>j
imap <C-k> <C-o>k
imap <C-l> <C-o>l
nmap <Space> <PageDown>
nmap n nzz
nmap N Nzz
nmap * *zz
nmap # #zz
nmap g* g*zz
nmap g# g#zz

function! MyFoldText()
	let line = getline(v:foldstart)
	let nucolwidth = &fdc + &number * &numberwidth
	let windowwidth = winwidth(0) - nucolwidth - 3
	let foldedlinecount = v:foldend - v:foldstart

" expand tabs into spaces
"  let onetab = strpart(' ', 0, &tabstop)
"  let line = substitute(line, '\t', onetab, 'g')
"  let line = strpart(line, 0, windowwidth - 2 - len(foldedlinecount))
"  let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
" return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . '…' . ' '
endfunction

set foldtext=MyFoldText()
set foldcolumn=0 " Ширина строки где располагается фолдинг
set foldmethod=indent " Фолдинг по отступам
set foldnestmax=10 " Глубина фолдинга 10 уровней
set nofoldenable " Не фолдить по умолчанию
set foldlevel=1 " This is just what i use
set fillchars="fold: " " remove the extrafills -------
vnoremap < <gv
vnoremap > >gv
set pastetoggle=<Leader>p
set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz
set showmatch

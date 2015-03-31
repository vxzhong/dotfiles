" vim: set sw=2 ts=2 sts=2 et tw=78 spell


" Startup {{{======================
" Note: Skip initialization for vim-tiny or vim-small.
if !1 | finish | endif
if !&compatible | set nocompatible | endif

" release autogroup in MyAutoCmd {{{
augroup MyAutoCmd
  autocmd!
augroup END
"}}}

" OS {{{
let s:is_windows = has('win16') || has('win32') || has('win64')
let s:is_cygwin = has('win32unix')
function! IsWindows()
  return s:is_windows
endfunction
function! IsMac()
  return !s:is_windows && !s:is_cygwin
        \ && (has('mac') || has('macunix') || has('gui_macvim') ||
        \   (!executable('xdg-open') &&
        \     system('uname') =~? '^darwin'))
endfunction
"}}}

" Cache {{{
let $CACHE = expand('~/.vim/.cache')
if !isdirectory(expand($CACHE))
  call mkdir(expand($CACHE), 'p')
endif
"}}}

" Encoding {{{
set encoding=utf-8 "Sets the character encoding used inside Vim
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,gb2312,cp936,chinese,latin1 "A list of character encodings
language messages en
" }}}

"}}}

" vim-plug {{{====================
if has('vim_starting')
  if IsWindows()
    let &runtimepath = join([
          \ expand('~/.vim'),
          \ expand('$VIMRUNTIME'),
          \ expand('~/.vim/after')], ',')
  endif
endif

if !isdirectory(expand('~/.vim/autoload'))
  silent call mkdir(expand('~/.vim/autoload'), 'p')
endif

if !isdirectory(expand('~/.vim/bundle'))
  silent call mkdir(expand('~/.vim/bundle'), 'p')
endif

if finddir('vim-plug', expand('~/.vim/bundle')) == ''
  echon 'Installing vim-plug...'
  silent !git clone https://github.com/junegunn/vim-plug.git $HOME/.vim/bundle/vim-plug
  echo 'done.'
  if v:shell_error
    echoerr 'vim-plug installation has failed!'
    finish
  endif
endif

if has('vim_starting')
  if IsWindows()
    silent !copy expand('~/.vim/bundle/vim-plug/plug.vim') expand('~/.vim/autoload')
  else
    silent !cp expand('~/.vim/bundle/vim-plug/plug.vim') expand('~/.vim/autoload')
  endif
endif

call plug#begin(expand('~/.vim/bundle'))

Plug 'junegunn/vim-plug'

" Colors {{{
Plug 'altercation/vim-colors-solarized'
Plug 'tomasr/molokai'
"}}}

" Enhance vim {{{
Plug 'bling/vim-airline'
Plug 'Lokaltog/vim-easymotion'
Plug 'Raimondi/delimitMate'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'matchit.zip'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'
"}}}

" tag {{{
Plug 'majutsushi/tagbar'
", { 'on': 'TagbarToggle'}
"}}}

" Find {{{
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tacahiroy/ctrlp-funky'
Plug 'mileszs/ack.vim'
"}}}

" autocomplete {{{
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'Valloric/YouCompleteMe', {'for': ['c', 'cpp', 'go', 'python']}
"}}}

" Go {{{
Plug 'fatih/vim-go', {'for': 'go'}
"}}}

" javascript {{{
Plug 'kchmck/vim-coffee-script'
"}}}

call plug#end()
"}}}

" Vim Setup  {{{====================

" Basic Options {{{
filetype plugin indent on " Enable detection, plugins and indenting in one step
if exists('&ambiwidth')
  set ambiwidth=double "Use twice the width of ASCII characters for Multibyte
endif
set autoread "Automatically read file again which has been changed outside of Vim
set backspace=indent,eol,start "Working of <BS>,<Del>,CTRL-W,CTRL-U
if has('unnamedplus')
  set clipboard& clipboard=unnamedplus "uses the clipboard register '+'
else
  set clipboard& clipboard+=unnamed,autoselect
endif
set cmdheight=1 "Number of screen lines to use for the command-line
set cmdwinheight=5 "Number of screen lines to use for the command-line window
set display=lastline "Display as much as possible of the last line
set diffopt+=iwhite
set formatoptions-=r,o " Turn off Automatically comment out when line break
" If we have Vim 7.4, add j to the format options to get rid of comment
" leaders when joining lines
if v:version >= 704
    set formatoptions+=j
endif
set grepprg=internal "Program to use for the :grep command
set helpheight=12 " Minimal initial height of the help window
set helplang& helplang=en,zh " If true Vim master, use English help file
set hidden "Display another buffer when current buffer isn't saved.
set history=1024 "Amount of Command history
set infercase "Ignore case on insert completion.
set keywordprg=:help " Open Vim internal help by K command
set laststatus=2 "Always display statusline
set matchpairs& matchpairs+=<:> "Characters that form pairs
set matchtime=1 "Tenths of a second to show the matching paren
set modeline "Set Vim local buffer option to specific file
set noerrorbells "Don't ring the bell for error messages
set novisualbell "Don't use visual bell instead of beeping
set nrformats-=octal "Bases Vim will consider for numbers(Ctrl-a,Ctrl-x)
set number "Print the line number in front of each line
set ruler "Show the line and column number of the cursor position
set shortmess& shortmess+=I "Don't give the message when starting Vim :intro
set showcmd "Show (partial) command in the last line of the screen
set showmatch "Briefly jump to the matching one
set spell " Spell checking on
set spelllang=en,cjk "Spell checking language
set textwidth=0 "Maximum width of text that is being inserted
set viewoptions=cursor,folds "Changes the effect of the :mkview command
set viminfo+=! "Store information when you exit Vim for later
set virtualedit=block "Cursor can be positioned virtually when Visual-block mode
set whichwrap=b,s,h,l,[,],<,> "Allow specified keys to move to the previous/next line
set wrap "Lines longer than the width of the window will wrap
set wrapscan "Searches wrap around the end of the file
set mouse=a " Enable mouse
set showmode " Display the current mode
set cursorline " Highlight current line
set winaltkeys=no " Turns off the Alt key bindings to the gui menu
set timeoutlen=3000 " Keymapping timeout
set ttimeoutlen=100
set splitright " Puts new vsplit windows to the right of the current
set splitbelow " Puts new split windows to the bottom of the current
set fileformat=unix  " Default fileformat
set fileformats=unix,dos,mac "This gives the end-of-line (<EOL>) formats

" Tab Basic Settings {{{
set autoindent "Copy indent from current line when starting a new line
"set expandtab "Use the appropriate number of spaces to insert a <Tab>
set shiftround "Round indent to multiple of 'shiftwidth'
set shiftwidth=2 "Number of spaces to use for each step of (auto)indent
set softtabstop=2 "Number of spaces that a <Tab> counts for while editing operations
set tabstop=2 "Number of spaces that a <Tab> in the file counts for
"}}}

" Search Basic Settings {{{
set incsearch "Incremental searching
set ignorecase "Ignore case in search patterns
set smartcase "Override the ignorecase option if the pattern contains upper case
set hlsearch | nohlsearch "Highlight search patterns, support reloading
"}}}

" Backup Settings {{{
if ! isdirectory(expand($CACHE.'/vimbackup'))
  call mkdir(expand($CACHE.'/vimbackup'), 'p')
endif
set backup "Make a backup before overwriting a file
set writebackup "Make a backup before overwriting a file
set backupdir=$CACHE/vimbackup "List of directories for the backup file
" Make backup files like you are millionaire (in terms disk usage resourses)
autocmd MyAutoCmd BufWritePre * let &backupext = '_' . strftime('%Y%m%d_%X') . '~'
"}}}

" Swap Settings {{{
if ! isdirectory(expand($CACHE.'/vimswap'))
  call mkdir(expand($CACHE.'/vimswap', 'p'))
endif
set swapfile "Use a swapfile for the buffer
set directory=$CACHE/vimswap
"}}}

" Undo Basic {{{
if has('persistent_undo')
  if ! isdirectory(expand($CACHE.'/vimundo'))
    call mkdir(expand($CACHE.'/vimundo', 'p'))
  endif
  set undofile "Automatically saves undo history
  set undoreload=1000 "Save the whole buffer for undo when reloading it
  set undodir=$CACHE/vimundo
  set undofile
endif
"}}}

" Wildmenu {{{
set wildmenu " Command line autocompletion
set wildmode=list:longest,full "Shows all the options

set wildignore& " A file that matches with one of these patterns is ignored
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.bak,*.?~,*.??~,*.???~,*.~      " Backup files
set wildignore+=*.luac                           " Lua byte code
set wildignore+=*.jar                            " Java archives
set wildignore+=*.pyc                            " Python byte code
set wildignore+=*.stats                          " Pylint stats

" }}}

" Fold Basic Settings "{{{
set foldenable "Enable fold
set foldlevel=100 "Folds with a higher level will be closed
"}}}

" Colorscheme {{{
if has('vim_starting')
  syntax enable
  set background=dark
  set t_Co=256
  if &t_Co < 256
    colorscheme default
  else
    try
      colorscheme molokai
    catch
      colorscheme desert
    endtry
  endif
endif
"}}}

" GUI {{{
  set guioptions-=T           " Remove the toolbar
  set lines=40                " 40 lines of text instead of 24
  if IsWindows()
    set guifont=Andale_Mono:h11,Menlo:h11,Consolas:h11,Courier_New:h11
  elseif IsMac()
    set guifont=Andale\ Mono\ Regular:h12,Menlo\ Regular:h11,Consolas\ Regular:h12,Courier\ New\ Regular:h14
  else
    set guifont=Andale\ Mono\ Regular\ 12,Menlo\ Regular\ 11,Consolas\ Regular\ 12,Courier\ New\ Regular\ 14
  endif
"}}}

"}}}

" Open & AutoReload .vimrc {{{
command! EVimrc e $MYVIMRC
command! ETabVimrc tabnew $MYVIMRC
command! SoVimrc source $MYVIMRC
autocmd MyAutoCmd BufWritePost *vimrc source $MYVIMRC
autocmd MyAutoCmd BufWritePost *gvimrc if has('gui_running') source $MYGVIMRC
"}}}

" Useful Keymaps{{{

" Map leader to ',' {{{
let g:mapleader = ','
nnoremap ,  <Nop>
xnoremap ,  <Nop>
"}}}

" Breakline with Enter {{{
nnoremap <CR> o<ESC>
"}}}

" Clear highlight. {{{
nnoremap <ESC><ESC> :nohlsearch<CR>:match<CR>
"}}}

" For Undo Revision, Break Undo Sequence "{{{
"inoremap <CR> <C-g>u<CR>
"inoremap <C-h> <C-g>u<C-h>
"inoremap <BS> <C-g>u<BS>
"inoremap <Del> <C-g>u<Del>
"inoremap <C-d> <C-g>u<Del>
"inoremap <C-w> <C-g>u<C-w>
"inoremap <C-u> <C-g>u<C-u>
"}}}

" Motion {{{

" Normal Mode {{{
nnoremap j gj
vnoremap j gj
nnoremap gj j
vnoremap gj j

nnoremap k gk
vnoremap k gk
nnoremap gk k
vnoremap gk k
"}}}

" Scroll {{{
nnoremap <C-e> <C-e>j
nnoremap <C-y> <C-y>k
nnoremap <C-f> <C-f>zz
nnoremap <C-b> <C-b>zz

nnoremap <Space>j <C-f>zz
nnoremap <Space>k <C-b>zz
vnoremap <Space>j <C-f>zz
vnoremap <Space>k <C-b>zz
"}}}

"}}}

" Paste in insert and Command-line mode"{{{
"inoremap <C-y><C-y> <C-r>+
"cnoremap <C-y><C-y> <C-r>+
"}}}

" Vertical Paste"{{{
"vnoremap <C-p> I<C-r>+<ESC><ESC>
"}}}

" Save as root"{{{
"cnoreabbrev w!! w !sudo tee > /dev/null %
"}}}

" From the cursor to the end of line {{{
" Select from cursor position to end of line
" vnoremap v $h " -> D,C,Y
" Yank from cursor position to end of line
nnoremap Y y$
"}}}

" Yank with keeping cursor position in visual mode {{{
"function! s:keepcursor_visual_wrapper(command)
"  exec "normal! gv" . a:command
"  exec "normal! gv\<ESC>"
"endfunction
"xnoremap <silent> y :<C-u>call <SID>keepcursor_visual_wrapper('y')<CR>
"xnoremap <silent> Y :<C-u>call <SID>keepcursor_visual_wrapper('Y')<CR>
"}}}

" select last inserted text
"nnoremap gV `[v`]

" Select pasted text
"nnoremap <expr>gp '`['.strpart(getregtype(),0,1).'`]'

" Don't use register by x
"nnoremap x "_x
"}}}

" set nopaste when Insertleave"{{{
autocmd MyAutoCmd InsertLeave * set nopaste
"}}}

" Show invisibles {{{

" Shortcut to rapidly toggle `set list`
"nnoremap <silent> <Leader>l :<C-u>set list! list?<CR>

" Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:▸\ ,
set list

function! s:remove_trailing_white_spaces()
  let pos = winsaveview()
  silent! execute '%s/\s\+$//g'
  call winrestview(pos)
endfunction
command! RemoveTrailingWhiteSpaces call <SID>remove_trailing_white_spaces()
command! -range=% TrimSpace  <line1>,<line2>s!\s*$!!g | nohlsearch
" remove trail ^M
command! -range=% RemoveTrailM  <line1>,<line2>s!\r$!!g | nohlsearch
"}}}

" Resize splits when the window is resized {{{
autocmd MyAutoCmd VimResized * :wincmd =
"}}}

" Restore last cursor position when open a file {{{
autocmd MyAutoCmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
"}}}

" Create Directory Automatically {{{
autocmd MyAutoCmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
function! s:auto_mkdir(dir, force)  " {{{
  if !isdirectory(a:dir) && (a:force ||
  \  input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
    call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
  endif
endfunction  " }}}
"}}}

" Filetypes {{{

" CoffeeScript {{{
autocmd MyAutoCmd BufRead,BufNewFile,BufReadPre *.coffee   setlocal filetype=coffee
autocmd MyAutoCmd FileType coffee     setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd BufWritePost,FileWritePost *.coffee silent CoffeeMake! -cb | cwindow | redraw!
"}}}

" Markdown {{{
autocmd MyAutoCmd BufRead,BufNewFile *.md  set filetype=markdown
autocmd MyAutoCmd FileType markdown setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd Syntax markdown syntax sync fromstart

autocmd MyAutoCmd FileType markdown nnoremap <buffer><silent><Leader>= :<C-u>call append('.', repeat('=', strdisplaywidth(getline('.'))))<CR>
autocmd MyAutoCmd FileType markdown nnoremap <buffer><silent><Leader>- :<C-u>call append('.', repeat('-', strdisplaywidth(getline('.'))))<CR>
"}}}

autocmd MyAutoCmd FileType html setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd FileType yaml setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd FileType javascript setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd FileType less setlocal sw=2 sts=2 ts=2 et

autocmd MyAutoCmd FileType c   setlocal foldmethod=syntax
autocmd MyAutoCmd FileType cpp setlocal foldmethod=syntax

autocmd MyAutoCmd FileType ruby setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd FileType vim  setlocal sw=2 sts=2 ts=2 et

autocmd MyAutoCmd BufRead,BufNewFile *.scala  set filetype=scala
autocmd MyAutoCmd BufRead,BufNewFile *.sbt set filetype=sbt
autocmd MyAutoCmd FileType scala setlocal foldmethod=syntax
autocmd MyAutoCmd FileType scala setlocal sw=2 sts=2 ts=2 et

set tags+=.tags
"}}}

" end vim setup}}}

" Plugin settings {{{==============

" Builtin Vim plugins {{{

" netrw {{{
" When viewing directories, show nested tree mode
let g:netrw_liststyle=3
" Don't create .netrwhist files
let g:netrw_dirhistmax = 0
let g:netrw_winsize   = 15
"}}}
"}}}

" vim-airline {{{
if isdirectory(expand('~/.vim/bundle/vim-airline'))
  set laststatus=2 " Always show statusbar
  let g:airline_detect_paste=1 " Show PASTE if in paste mode
endif
"}}}

" ack.vim {{{
if isdirectory(expand('~/.vim/bundle/ack.vim'))
  if executable('ag')
    let g:ackprg = "ag --nocolor --nogroup --column"
  elseif executable('ack-grep')
    let g:ackprg = "ack-grep --nocolor --nogroup --column"
  elseif executable('ack')
    let g:ackprg = "ack --nocolor --nogroup --column"
  endif
endif
"}}}

" tagbar {{{
if isdirectory(expand('~/.vim/bundle/tagbar'))
  nnoremap <silent> <leader>tt :TagbarToggle<CR>
endif
"}}}

" vim-session {{{
if isdirectory(expand('~/.vim/bundle/vim-session'))
  let g:session_autoload        = 'yes'
  let g:session_autosave        = 'yes'
  let g:session_default_to_last = 'yes'
  let g:session_directory = expand('$CACHE/vimsessions')
endif
"}}}

" ctrlp.vim {{{
if isdirectory(expand('~/.vim/bundle/ctrlp.vim'))
  nnoremap <silent> <M-r> :CtrlPMRU<CR>
  nnoremap <silent> <M-b> :CtrlPBuffer<CR>
  let g:ctrlp_working_path_mode = 'raw'
  let g:ctrlp_custom_ignore = {
        \ 'dir':  '\.git$\|\.hg$\|\.svn$',
        \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }

  " On Windows use "dir" as fallback command.
  if IsWindows()
    let s:ctrlp_fallback = 'dir %s /-n /b /s /a-d'
  elseif executable('ag')
    let s:ctrlp_fallback = 'ag %s --nocolor -l -g ""'
  elseif executable('ack-grep')
    let s:ctrlp_fallback = 'ack-grep %s --nocolor -f'
  elseif executable('ack')
    let s:ctrlp_fallback = 'ack %s --nocolor -f'
  else
    let s:ctrlp_fallback = 'find %s -type f'
  endif
  let g:ctrlp_user_command = {
        \ 'types': {
        \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
        \ 2: ['.hg', 'hg --cwd %s locate -I .'],
        \ },
        \ 'fallback': s:ctrlp_fallback
        \ }

  if isdirectory(expand('~/.vim/bundle/ctrlp-funky'))
    " CtrlP extensions
    let g:ctrlp_extensions = ['funky']
  endif
endif
"}}}

" YouCompleteMe {{{
if isdirectory(expand('~/.vim/bundle/YouCompleteMe'))
    let g:ycm_autoclose_preview_window_after_completion = 1
    let g:ycm_min_num_identifier_candidate_chars = 4
    ""  let g:ycm_extra_conf_globlist = ['~/repos/*']
    ""  let g:ycm_filetype_specific_completion_to_disable = {'javascript': 1}
    " remap Ultisnips for compatibility for YCM

    let g:UltiSnipsExpandTrigger="<c-j>"
    let g:UltiSnipsJumpForwardTrigger="<c-j>"
    let g:UltiSnipsJumpBackwardTrigger="<c-k>"

    nnoremap <leader>y :YcmForceCompileAndDiagnostics<cr>
    nnoremap <leader>tg :YcmCompleter GoTo<CR>
    nnoremap <leader>td :YcmCompleter GoToDefinition<CR>
    nnoremap <leader>tc :YcmCompleter GoToDeclaration<CR>
endif
"}}}

" end plugin settings}}}

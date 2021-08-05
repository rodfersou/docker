"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General fixes
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nofoldenable    " disable folding
set encoding=UTF-8
set number
set autoread
au FocusLost,WinLeave * :silent! w

set clipboard=unnamedplus
function! ClipboardYank()
    call system('xclip -i -selection clipboard &> /dev/null', @@)
endfunction
function! ClipboardPaste()
    let @@ = system('xclip -o -selection clipboard &> /dev/null')
endfunction
vnoremap <silent> yy:call ClipboardYank()<cr>
vnoremap <silent> dd:call ClipboardYank()<cr>
nnoremap <silent> p:call ClipboardPaste()<cr>

colorscheme solarized
highlight Normal guibg=NONE ctermbg=NONE


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Fix Alt (Meta)
" https://stackoverflow.com/a/10216459
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if ! has("nvim")
    let c='a'
    while c <= 'z'
      exec "set <A-".c.">=\e".c
      exec "imap \e".c." <A-".c.">"
      let c = nr2char(1+char2nr(c))
    endw
    set timeout ttimeoutlen=50
    " set ttimeout ttimeoutlen=50
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Custom macros
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let @s='msgg/^fromV)k;sort i/^importV)k;sort i`s;noh'
let @d='oimport pdb; pdb.set_trace()import ipdb; ipdb.set_trace()import debug'
let @u='ofrom Products.CMFPlone.utils import safe_unicode'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Language Client
" (cd .vim_runtime/my_plugins && git clone --depth=1 --branch next https://github.com/autozimu/LanguageClient-neovim.git)
" (cd .vim_runtime/my_plugins/LanguageClient-neovim && bash install.sh)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:LanguageClient_autoStart = 1
let g:LanguageClient_serverCommands = {}
let g:LanguageClient_diagnosticsSignsMax = 0
set formatexpr=LanguageClient#textDocument_rangeFormatting_sync()
nnoremap <leader>lcs :LanguageClientStart<CR>
nnoremap <leader>l :call LanguageClient_contextMenu()<CR>
nnoremap ] :call LanguageClient#textDocument_definition()<CR>
nnoremap [ <C-O>
nnoremap & :call LanguageClient_textDocument_rename()<CR>
nnoremap <leader>r :call LanguageClient_textDocument_references()<CR>
let g:lsp_log_verbose = 1
let g:lsp_log_file = expand('~/lsp-logs')
let g:LanguageClient_serverCommands["python"] = ['pyls']

function! MaybeFormat() abort
    if !has_key(g:LanguageClient_serverCommands, &filetype)
        return
    endif

    call LanguageClient#textDocument_formatting_sync()
endfunction
autocmd BufWritePre * call MaybeFormat()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Nerd Tree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set splitright
set splitbelow

let g:NERDTreeChDirMode=0
let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
let NERDTreeMouseMode=2
let g:NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$', '\.bak$', '\~$']
let g:NERDTreeShowBookmarks=1
let g:nerdtree_tabs_focus_on_files=1
let NERDTreeKeepTreeInNewTab=1
let NERDTreeQuitOnOpen=1
function! s:CloseIfOnlyControlWinLeft()
  if winnr("$") != 1
    return
  endif
  if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
        \ || &buftype == 'quickfix'
    q
  endif
endfunction
augroup CloseIfOnlyControlWinLeft
  au!
  au BufEnter * call s:CloseIfOnlyControlWinLeft()
augroup END
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite
if has('gui_running')
  " Open by mouse click
  noremap <F12> :NERDTreeToggle %<CR>
else
  noremap <F12> :NERDTreeToggle<CR>
endif
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-multiple-cursors
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set selection=inclusive
let g:multi_cursor_start_word_key      = '<C-d>'
let g:multi_cursor_select_all_word_key = '<A-d>'
let g:multi_cursor_start_key           = 'g<C-d>'
let g:multi_cursor_select_all_key      = 'g<A-d>'
let g:multi_cursor_next_key            = '<C-d>'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-easy-align
" (cd .vim_runtime/my_plugins && git clone --depth=1 https://github.com/junegunn/vim-easy-align.git)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
if !exists('g:easy_align_delimiters')
  let g:easy_align_delimiters = {}
endif
let g:easy_align_delimiters['d'] = {
\ 'pattern': ' \ze\S\+\s*[;=]',
\ 'left_margin': 0, 'right_margin': 0
\ }


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => supertab
" (cd .vim_runtime/my_plugins && git clone --depth=1 https://github.com/ervandew/supertab.git)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => coc.vim
" (cd .vim_runtime/my_plugins && git clone --depth=1 --branch release https://github.com/neoclide/coc.nvim.git)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-devicons
" (cd /srv && git clone --depth=1 https://github.com/ryanoasis/nerd-fonts.git)
" (cd /srv/nerd-fonts && ./install.sh Hack)
" (cd .vim_runtime/my_plugins && git clone --depth=1 https://github.com/ryanoasis/vim-devicons.git)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Use ; as :
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
noremap ; :
" noremap : ;


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Easy save
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap ss :wa<cr>
nnoremap SS :xa<cr>
nnoremap zz :x<cr>
nnoremap ZZ :qa!<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Easy move
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
noremap j gj
noremap k gk
noremap <Down> gj
noremap <Up> gk
" tabs
nnoremap H gT
nnoremap L gt


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Fix tabs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set tabstop=4
set shiftwidth=4
set expandtab
autocmd BufWrite * :retab

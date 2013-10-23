set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'ledger/ledger', { 'rtp': 'contrib/vim/' }
Bundle 'snipMate'

au BufNewFile,BufRead *.ldg,*.ledger setf ledger | comp ledger

filetype plugin indent on

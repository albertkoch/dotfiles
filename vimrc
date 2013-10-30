set nocompatible		" Use vim settings not vi compatible
set cindent			" Use c style indenting
set backspace=2			" Allow backspacing over indent,start,eol
set showmatch			" Show matching [],(),{}
syntax enable			" Use syntax highlighting
set incsearch			" Use incremental search (start search for each letter)
set ruler			" Display the ruler
set wildmenu			" Show me what files match what I've typed
set wildmode=list:longest	" In shell format
set ignorecase			" Ignore the case of searches
set smartcase			" Unless there is a capital letter in my search

map <F2> :0o:%s/^>[	 ]*//:0!Gfmt:%s/^/> /:%s/^> $//:0xxjdd:0O:0i
map <F3> :%s/\(^On.*:$\)\(\n^>[ 	]*$\)*/\1/:%s/^>[ 	]*$\n\(\_^>[ 	]*$\n\)*/\r/:0

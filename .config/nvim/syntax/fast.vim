" ~/.vim/syntax/fast.vim

" Exit early if this syntax file has already been loaded.
if exists("b:current_syntax")
  finish
endif

" ============================================================================
" Syntax Definitions for .fast Files
" ============================================================================

" Comments: Lines starting with '#' until the end of the line.
syntax match fastComment /^\s*#.*/

" Keywords: Customize these based on your sample files.
" syntax keyword fastKeyword print

" Numbers: Numeric literals.
syntax match fastNumber /\<\d\+\>/

" Strings: Text enclosed in double quotes.
" The skip pattern \\." ignores escaped quotes.
syntax region fastString start=+"+ skip=+\\."+ end=+"+
syntax region fastString start=+`+ end=+`+

" Variables: A variable may start with '@' or '$' followed by alphanumeric/underscore characters.
syntax match fastVariable /[@$][A-Za-z_][A-Za-z0-9_]*/

" Functions: For example, if a function is defined with the keyword "func".
syntax keyword fastFunction thread exec loop perf bench read print set for signal wait waitfor sleep output status
" syntax match fastFunction /\w\+()/

" Blocks: Regions delimited by curly braces.
" The 'contains' list allows nested blocks and other constructs inside a block.
syntax region fastBlock start="{" end="}" contains=fastComment,fastKeyword,fastNumber,fastString,fastFunction,fastVariable,fastBlock

" ---------------------------------------------------------------------------
" Command Options:
" Some commands allow specifying options after a colon. For example:
"   exec:shell,runs=10,status=0 "/path/to/command"
" This definition handles the options as a single region that ends at a whitespace or end-of-line.
syntax region fastCommandOptions start=":" end="\(\s\|$\)" contains=fastOptAssign,fastOptSimple,fastOptComma oneline

" Inside the options region, we define:
"   - fastOptAssign for assignments (like runs=10 or status=0)
"   - fastOptSimple for simple option names (like shell)
"   - fastOptComma for commas as delimiters
syntax match fastOptAssign /\<[A-Za-z_]\w*=\S\+\>/ contained
syntax match fastOptSimple /\<[A-Za-z_]\w*\>/ contained
syntax match fastOptComma /,/ contained

" ============================================================================
" Highlight Group Linking
" Link each custom syntax group to an existing Vim highlight group.
highlight link fastComment    Comment
highlight link fastKeyword    Keyword
highlight link fastNumber     Number
highlight link fastString     String
highlight link fastVariable   Identifier
highlight link fastFunction   Function
highlight link fastBlock      Statement

" Command Options linking:
highlight link fastCommandOptions Type
highlight link fastOptAssign    Constant
highlight link fastOptSimple    Constant
highlight link fastOptComma     Delimiter

" ============================================================================
" Mark the syntax as loaded.
let b:current_syntax = "fast"


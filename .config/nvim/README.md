# My Neovim Configuration :fire:

<!-- vim: set spell: -->

## :package: Installation

Running `nvim` should install all plugins for you, no extra commands necessary.

## :lock: Optional Prerequisites

> **NOTE:** Most of these will be already installed if the dependency
> installation script was run.

- Use a font that is patched with the
  [Nerd Fonts library](https://github.com/ryanoasis/nerd-fonts) for status line,
  buffer line icons
- Install [`ripgrep`](https://github.com/BurntSushi/ripgrep#installation) for
  fuzzy finding files with keyword search
- Install
  [`wl-clipboard`](https://archlinux.org/packages/extra/x86_64/wl-clipboard/)
  (or [build from source](https://github.com/bugaevc/wl-clipboard#building)) if
  using Wayland in order to support yanking to the system clipboard
- Install [`nodejs`](https://nodejs.org/en) (with `npm`) for Markdown
  previewing, among many other things
- Install [unzip](https://archlinux.org/packages/extra/x86_64/unzip/) to allow
  Mason to unzip certain packages (like `deno` for formatting of
  Javascript-family files)
- Install `ghc` and `haskell-language-server` for Haskell development with
  [`haskell-tools.nvim`](https://github.com/mrcjkb/haskell-tools.nvim) (avoid
  installation of the Haskell Language Server with Mason due to compatibility
  troubles with `GHC`, see [Troubleshooting](#question-troubleshooting) for
  details)
- Install [`delta`](https://github.com/dandavison/delta.git) for nice Git diff
  highlighting
  - This also requires
    [`less`](https://archlinux.org/packages/core/x86_64/less/), which is usually
    installed already

## :rocket: Usage

This configuration extends all of the core functionality of Neovim. I use
`Space` as the Leader key. All mappings are in Normal mode unless specified
otherwise.

For best results use a terminal that supports ligatures (I use `Konsole` and
`WezTerm`).

### Basic

- Update plugins with `:Lazy update`
- Manage plugins via GUI with `:Lazy`
- Install `LSP`'s, formatters, etc. with `:LspInstall` or with `:Mason`:
  - `i` to install current package
  - `u` to update current package
  - `X` to remove current package
- Install syntax highlighters for a given file type with `:TSInstall {filetype}`
- Change/preview color schemes with `<leader>fc`

### Navigation

- Files
  - Use `<leader>ff` to fuzzy Find Files
    - Files that are already opened are ignored
  - Use `<leader>fg` to Grep Files against a fixed input query (more performant,
    better for large projects)
  - Use `<leader>fs` to live Search for Files that contain a phrase (using
    `ripgrep`)
  - Use `<leader>fw` to fuzzy find Files in the git Working tree and index
  - **NOTE**:
    - Use `Enter` to switch to selected file
    - Use `Tab` to open selected file(s) in new tab
    - Use `<Space>` (`<C-Space>` in Insert mode) to toggle whether a file is
      selected
    - Use `<C-l>` and `<C-h>` to scroll the preview right and left, respectively
    - Use `q` to quit
- Tabs
  - Use `Ctrl+n` and `Ctrl+p` to switch to one tab to the left or right,
    respectively
  - Use `Ctrl+h` and `Ctrl+l` to move tabs to the left of right, respectively
  - Use `Ctrl+t` to open a new tab
- In-buffer
  - Use `H` and `L` as aliases for `_` and `g_`, respectively (move to first and
    last position of the line, respectively (excluding whitespace))
  - Use `<leader>k` and `<leader>j` to the beginning and end of the current
    indent scope, respectively.
- Git
  - Use `<leader>gk` and `<leader>gj` to move up and down Git changes,
    respectively
- Diagnostics
  - For the following key maps, make the suffix capital to open in a new tab
    (e.g. `gD` opens definition in new tab)
    - Use `gd` to Go to Definition of current object
    - Use `gt` to Go to Type definition of current object
    - Use `gi` to Go to Implementation of current object
    - Use `<leader>gd` to Go to Declaration of current object
  - Use `gr` to Go to References of current object
  - Use `<leader>dj` and `<leader>dk` to go to next or previous Diagnostic,
    respectively
- Insert mode
  - Prepend `Ctrl` to `h`, `j`, `k`, `l` to navigate as in Normal mode
    - This also works with `w`, `e`, and `b`
  - Use `<M-BS>` to delete a word
  - Can use `Meta+i` as an alternative to `Esc` to exit Insert mode
- Use `<leader>sj` and `<leader>sk` to move to the next and previous
  misspellings, respectively

### Editing

By default this configuration formats text on save (if a formatter is found for
that file). Save without formatting with `:W`.

- File Tree
  - Use `<leader>ft` to open the file Tree
  - Create new files or directories with `n` and trash them with `d`
  - Mark files with `m` or `t` to perform bulk operations
    - E.g., open multiple files in new tabs with `<Tab>` (also works without a
      selection)
  - Other mappings can be found in the `lua/plugins/ui.lua` file
- LSP
  - Use `<leader>ca` to run Code Actions through the LSP
  - Use `<leader>cl` to run Code Lens through the LSP
  - Use `<leader>r` to smartly rename variables with the LSP
- Use `Ctrl+/` to toggle comments
  - In Normal and Insert mode, toggles current line
  - In Visual mode, toggles selected lines (or text if only one line selected)
  - For advanced uses with motions, use `gc` for line and `gb` for block
- Autocompletion
  - Use `Tab` to select current item, jump to next snippet position (VS Code
    functionality)
  - Use `Shift+Tab` to navigate to previous item, jump to previous snippet
    position
  - Use `Ctrl+n` and `Ctrl+p` to navigate to Next or Previous item, respectively
  - Use `Ctrl+e` to Exit autocompletion menu
  - Use `Ctrl+Space` to show full autocompletion menu
- Git
  - Use `<leader>gu` to Undo a Git change (works in Normal and Visual mode)
  - Use `<leader>gr` to Reset (undo) _all_ Git changes in a file
  - Use `<leader>ga` to Add (stage) a Git change (works in Normal and Visual
    mode)
- `EZ Semicolon`
  - Implements `EZ Semicolon` (VS Code extension) functionality: inserting a
    semicolon anywhere will always place it at the end of the line followed by a
    new line. The only exceptions to this are if the line is a return statement
    (no new line will be inserted) or a for loop (no formatting will occur at
    all). This behavior can be overridden by using `Meta+;`.
- Indentation
  - Use `Tab` and `Shift+Tab` to indent or remove indent, respectively
    - In Normal mode, this affects the current line. In Visual mode, this
      affects all selected lines.
  - Use, in Insert mode, `Ctrl+d` and `Ctrl+f` (or `Shift+Tab` and `Tab`) to
    decrease or increase bullet point indentation, respectively.
- Search and Replace
  - Use `<leader>h` to search and replace instances of the hovered word
  - Use a capital `H` to smartly match different cases like `camelCase`,
    `PascalCase`, etc. (but without incremental search)
- Miscellaneous useful Visual mode operations
  - Prefix the `h`, `j`, `k`, and `l` motions with `Ctrl` to move the _end_ of
    the selection
  - Surround selection with brackets by pressing `s` or `S` then that bracket.
    Open bracket surrounds with spaces in-between and closed bracket surrounds
    without spaces.
    - Example (asterisk demarcates the selection): `*surround* here` -> `S(` ->
      `( surround ) here`
    - **NOTE:** Surround with HTML-style tag using `T`
  - Use `Ctrl+y` and `Ctrl+x` to copy or cut to system clipboard, respectively
- Other useful surround operations
  - All defaults provided in
    [`nvim-surround`](https://github.com/kylechui/nvim-surround) with some nice
    aliases
  - Use `f` postfix to surround with function call
    - Capital `F` surrounds with a function definition in Lua and
      Javascript-family files
  - Use `g` postfix to surround with a generic instantiation
    - E.g. `ysiwgArray<CR>` to surround a word with `Array<`, `>` (or `Array[`,
      `]` in Go)
  - Use `b` postfix to make selection Bold (surround with `**`) in Markdown
- Tree-sitter
  - Custom text object motions using Tree-sitter (all motions support `a` and
    `i` variants)
    - `f`: Function call
    - `F`: Function implementation
    - `L`: Loop
    - `l`: Line
    - `a`: Arguments, parameters, and array elements
    - `c`: Conditional
    - `C`: Class
    - `r`: Return blocks
    - `/`: Comment
    - `$` or `m`: LaTeX blocks (in Markdown)
    - `i`: Current indentation level
  - `<leader>sh` and `<leader>sl` to Swap nodes to the left and right,
    respectively
- Additionally, use `aa` motion to select entire buffer
  - (Can also use `ia` to get text contents without the final newline)
- Miscellaneous niceties
  - Insert new lines in Normal mode with `Enter` (line(s) below) or
    `Shift+Enter` (line(s) above)
  - Use `gq` with a motion for wrapping long comments in Python.
  - Redo with `U`
  - Duplicate and comment selected lines or current line for Testing with
    `<leader>t`
  - Use `gw` and a motion (or in Visual mode) to wrap text (useful for Python
    comments)
    - This is default Vim functionality, this bullet is essentially a
      note-to-self
    - Also works with `gq` (though the two are slightly different)
  - Use `<leader>sf` to Fix the Spelling of the word under the cursor
  - Use `<leader>si` to Ignore the Spelling of the word under the cursor
    (surround it with backticks)

### Viewing

- Use `Esc` to clear search highlighting
- Use `K` to hover over the current object, showing LSP information
- Use `<leader>e` to show current error information
- Use `<leader>bx` to close all tabs except the current
- Use `:M` (or `:MarkdownPreview`) to preview a markdown file
- Use `<leader>w` to toggle line Wrap for the current buffer
- Git
  - Use `<leader>gp` to Preview a Git change that the cursor is on
  - Use `<leader>gb` to Git-Blame the current line
- Folding
  - Use `<leader>z` to toggle current fold
    - Performing this operation in Visual mode will create a fold of the
      selected lines
  - Use `zn` and `zp` to traverse Next and Previous closed folds, respectively
  - Use `zf` to Focus (close all folds except) the current fold
  - Use `zF` to Focus (close all folds except) the current fold and its children
  - Use `zO` to Open all folds
  - Use `zo` to Open all folds descending from the fold at the current line
- Using Git with `fzf-lua`
  - `<leader>gs` to Get Git Status
  - `<leader>gc` to Get Git Commits
  - `<leader>gh` to Get Git Hunks (change History of current buffer)
- Arbitrary Tree-sitter language injections for Lua using comments like:
  ```lua
  --> INJECT: javascript
  local js_string = [[
  console.log('hello')
  ]]
  ```

### Snippets

Inherits all snippets provided by the LSP. Additionally...

- Emmet snippets for HTML and other file types
- `lorem`: snippet for Markdown and Emmet-supported file types that provides a
  long `lorem ipsum...` string
- Many LaTeX snippets (with Markdown math-mode detection) inspired by
  [Gilles Castel](https://castel.dev/)
- Other useful Markdown snippets
  - Generate Markdown tables with `tbl<row_num>x<col_num>`
  - Flowchart and sequence diagram snippets

### Debugging

- Check base startup time with `:StartupTime`
- Check plugin loading information with `:Lazy profile`
- Use `:I` and `:IT` aliases for `:Inspect` and `:InspectTree`, respectively
- Use `gh` to Get Help under the current word or selection

## :question: Troubleshooting

- **NOTE:** To support `<S-CR>` on `Konsole`, go to
  `Settings>Edit Current Profile>Keyboard` and change the `Return+Shift` mapping
  key code from `\EOM` (or whatever the current value is) to `\E[13;2u`.
- If the post install hook doesn't work when first installing `tree-sitter`, run
  `:TSUpdate` manually and it should work.
- If you get an error when opening a certain file type:
  ```
  Error executing lua: ...query: invalid node type at position...
  ```
  run `:TSInstall {filetype}` (or enter the valid name for the tree sitter
  highlighter for that file type) and this should fix it.
- If you get an error relating to `rust-analyzer` not being found or executable
  when opening Rust files, this may be because Mason's installed version cannot
  be executed due to shared library issues(?) and if this is the case it may be
  best to just keep the Mason installation (for compatibility reasons) and
  install the `rust-analyzer` binary on your machine regularly.
- If you get errors related to the Haskell Language Server not being found even
  after you have installed `ghc` and `hls`, this is because the version of `ghc`
  is not yet working in tandem with `hls`. In the `ghcup tui`, make sure your
  version of `GHC` says `hls-powered` in the `Notes` section on the right. Once
  you have done this set that version of `GHC` using `s` in the TUI and then
  `ghc install hls`. It is not recommended to install the Haskell Language
  Server with Mason.

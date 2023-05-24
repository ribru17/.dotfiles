# My Neovim Configuration :fire:

## :camera: Screenshot

- Font: [Iosevka](https://github.com/ribru17/iosevka-config), Custom Extended
  15pt
- Theme: [Catppuccin](https://github.com/catppuccin/nvim)

![nvimhome](https://user-images.githubusercontent.com/55766287/234681330-0933305d-0c2d-47e9-90ba-94535aaf616f.png)
![nvimediting](https://user-images.githubusercontent.com/55766287/229266560-df25e8c6-fd4e-495e-876d-7a890840815e.png)

## :package: Installation

Run `git clone --depth 1 https://github.com/ribru17/nvim.git` in your
`~/.config` directory (`~/AppData/Local` on Windows). Running `nvim` should
install all plugins for you, no extra commands necessary.

## :lock: Optional Prerequisites

- Use a font that is patched with the
  [Nerd Fonts library](https://github.com/ryanoasis/nerd-fonts) for statusline,
  bufferline icons
- Install [ripgrep](https://github.com/BurntSushi/ripgrep#installation) for
  fuzzy finding files with keyword search
- Install
  [wl-clipboard](https://archlinux.org/packages/community/x86_64/wl-clipboard/)
  (or [build from source](https://github.com/bugaevc/wl-clipboard#building)) if
  using Wayland in order to support yanking to the system clipboard
- Install [Deno](https://deno.land/manual@v1.31.1/getting_started/installation)
  for `deno fmt` (formatting of Javascript-family files and Markdown)
- Install [unzip](https://archlinux.org/packages/extra/x86_64/unzip/) to allow
  Mason to unzip LSP packages
- Install `prettierd` via Mason for formatting of files that `deno fmt` doesn't
  support (CSS, HTML, etc.)
- Install `clang_format` via Mason for C, C++ formatting (`clangd` enables
  formatting but it's not extensible with `null-ls`)

## :rocket: Usage

This configuration extends all of the core functionality of Neovim. I use
`Space` as the Leader key. All mappings are in Normal mode unless specified
otherwise.

For best results use a terminal that supports ligatures (I use Konsole and
WezTerm)

### Basic

- Update plugins with `:Lazy update`
- Manage plugins via GUI with `:Lazy`
- Install LSP's, formatters, etc. with `:LspInstall` or with `:Mason`:
  - `i` to install current package
  - `u` to update current package
  - `X` to remove current package
- Install syntax highlighters for a given filetype with `:TSInstall {filetype}`
- Change/preview color schemes with `<leader>fc`

### Navigation

- Files
  - Use `<leader>ff` to fuzzy Find Files
  - Use `<leader>fg` to Grep Files against a fixed input query (more performant,
    better for large projects)
  - Use `<leader>fs` to live Search for Files that contain a phrase (using
    ripgrep)
  - Use `<leader>fw` to fuzzy find Files in the git Working tree and index
  - **NOTE**:
    - Use `Enter` to switch to selected file
    - Use `Tab` to open selected file(s) in new tab
    - Use `t` (`Ctrl+t` in Insert mode) to toggle whether a file is selected
    - Use `q` to quit
- Tabs
  - Use `Ctrl+n` and `Ctrl+p` to switch to one tab to the left or right,
    respectively
    - I chose these directions because they make more sense to me as `n` is on
      the left and `p` is on the right on a keyboard
  - Use `Ctrl+h` and `Ctrl+l` to move tabs to the left of right, respectively
  - Use `Ctrl+t` to open a new tab
- Git
  - Use `<leader>gk` and `<leader>gj` to move up and down Git changes,
    respectively
  - Use `<leader>gp` to Preview a Git change that the cursor is on
  - Use `<leader>gb` to Git-Blame the current line
- Diagnostics
  - Use `gd` to Go to Definition of current object
  - Use `gD` to Go to Definition of current object in a new tab
  - Use `<leader>dj` and `<leader>dk` to go to next or previous Diagnostic,
    respectively
- Insert mode
  - Prepend `Ctrl` to `h`, `j`, `k`, `l` to navigate as in Normal mode
    - This also works with `w`, `e`, and `b`
  - Can use `Meta+i` as an alternative to `Esc` to exit Insert mode

### Editing

By default this configuration formats text on save (if a formatter is found for
that file). Save without formatting with `:W`.

- File Tree
  - Use `<leader>t` to open the file Tree
  - Create new files or directories with `n` and trash them with `d`
  - Other mappings can be found in the `lua/plugins/coding.lua` file
- LSP
  - Use `<leader>ca` to run Code Actions through the LSP
  - Use `<leader>cl` to run Code Lens through the LSP
  - Use `<leader>r` to smartly rename variables with the LSP
- Use `Ctrl+/` to toggle comments
  - In Normal and Insert mode, toggles current line
  - In Visual mode, toggles selected lines (or text if only one line selected)
- Autocompletion
  - Use `Tab` to select current item, jump to next snippet position (VS Code
    functionality)
  - Use `Shift+Tab` to navigate to previous item, jump to previous snippet
    position
  - Use `Ctrl+n` and `Ctrl+p` to navigate to Next or Previous item, respectively
  - Use `Ctrl+e` to Exit autocompletion menu
  - Use `Ctrl+Space` to show full autocompletion menu
- Git
  - Use `<leader>gu` to Undo a Git change
  - Use `<leader>gr` to Reset (undo) _all_ Git changes
- EZ Semicolon
  - Implements EZ Semicolon (VS Code extension) functionality: inserting a
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
  - Use a capital `H` to smartly match different cases like camelCase,
    PascalCase, etc. (but without incremental search)
- Miscellaneous useful Visual mode operations
  - Use `K` and `J` to move the selected lines up or down, respectively, smartly
    indenting if the lines move within the scope of, say, an if statement
  - Prefix the `h`, `j`, `k`, and `l` motions with `Ctrl` to move the _end_ of
    the selection
  - Surround selection with brackets by pressing `s` or `S` then that bracket.
    Open bracket surrounds with spaces in-between and closed bracket surrounds
    without spaces.
    - Example (asterisk demarcates the selection): `*surround* here` -> `S(` ->
      `( surround ) here`
    - **NOTE:** Surround with HTML-style tag using `T`
  - Use `Ctrl+y` and `Ctrl+x` to copy or cut to system clipboard, respectively
  - Use `aa` to select the entire buffer
- Other useful surround operations
  - All defaults provided in
    [nvim-surround](https://github.com/kylechui/nvim-surround) with some nice
    aliases
  - Use `f` postfix to surround with function call
    - Capital `F` surrounds with a function definition in Lua files
- Insert new lines in Normal mode with `Enter` (line(s) below) or `Shift+Enter`
  (line(s) above)

### Viewing

- Use `Esc` to clear search highlighting
- Use `K` to hover over the current object, showing LSP information
- Use `<leader>e` to show current error information
- Use `:M` (or `:MarkdownPreview`) to preview a markdown file
- Folding
  - Use `<leader>z` or `zz` to toggle current fold
    - Performing these operations in Visual mode will create a fold of the
      selected lines
  - Use `zf` to Focus (close all folds except) the current fold
  - Use `zO` to Open all folds
  - Use `zo` to Open all folds descending from the fold at the current line

### Snippets

Inherits all snippets provided by the LSP. Additionally...

- `!`: snippet for HTML (Emmet style) that provides a generic HTML5 template
- `lorem`: snippet for all filetypes that provides a long lorem ipsum string
- Some Markdown Tex snippets inspired by [Gilles Castel](https://castel.dev/).

### Debugging

- Check base startup time with `:StartupTime`
- Check plugin loading information with `:Lazy profile`

## :question: Troubleshooting

- **NOTE:** To support `<S-CR>` on Konsole, go to
  `Settings>Edit Current Profile>Keyboard` and change the `Return+Shift` mapping
  keycode from `\EOM` (or whatever the current value is) to `\E[13;2u`
- If, after quitting Neovim in a Markdown file, you get the error:
  ```
  client 2 quit with exit code 143 and signal 0
  ```
  uninstall the `marksman` LSP with Mason.
- If the post install hook doesn't work when first installing `tree-sitter`, run
  `:TSUpdate` manually and it should work.
- If you get an error when opening a certain file type:
  ```
  Error executing lua: ...query: invalid node type at position...
  ```
  run `:TSInstall {filetype}` (or enter the valid name for the tree sitter
  highlighter for that filetype) and this should fix it.
- If you get an error relating to `rust-analyzer` not being found or executable
  when opening Rust files, this may be because Mason's installed version cannot
  be executed due to shared library issues(?) and if this is the case it may be
  best to just keep the Mason installation (for compatibility reasons) and
  install the `rust-analyzer` binary on your machine regularly

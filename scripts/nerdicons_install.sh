mkdir -p ~/.local/share/fonts/nerd/
wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/NerdFontsSymbolsOnly/SymbolsNerdFont-Regular.ttf &&
    mv SymbolsNerdFont-Regular.ttf ~/.local/share/fonts/nerd/
wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/NerdFontsSymbolsOnly/SymbolsNerdFontMono-Regular.ttf &&
    mv SymbolsNerdFontMono-Regular.ttf ~/.local/share/fonts/nerd/
fc-cache
echo 'Installed "Symbols Only" Nerd Font'

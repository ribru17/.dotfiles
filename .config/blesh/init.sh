#!/bin/bash

# suppress error output
bleopt exec_errexit_mark=''
bleopt term_index_colors=auto

# case insensitive auto-complete
bind 'set completion-ignore-case on'

# for kitty
ble-bind -m auto_complete -f C-i auto_complete/insert
ble-bind -f 'M-DEL' kill-backward-cword
ble-bind -m vi_imap -f 'M-DEL' kill-backward-cword
# for wezterm
ble-bind -m auto_complete -f TAB auto_complete/insert
ble-bind -f 'M-C-?' kill-backward-cword
ble-bind -m vi_imap -f 'M-C-?' kill-backward-cword

# colors
ble-face -s argument_option fg=#f08080,italic
ble-face -s auto_complete fg=#5b5e5a,italic
ble-face -s command_alias fg=blue
ble-face -s command_builtin fg=#ff9966
ble-face -s command_file fg=blue
ble-face -s command_function fg=blue
ble-face -s filename_directory fg=#96c7ef,italic,underline
ble-face -s filename_executable fg=green,bold
ble-face -s filename_orphan fg=cyan,bold,underline
ble-face -s region_insert bg=#3a3d37
ble-face -s syntax_error fg=red
ble-face -s syntax_escape fg=#f08080
ble-face -s syntax_quotation fg=green
ble-face -s varname_readonly fg=#ff9966
ble-face -s varname_unset fg=red

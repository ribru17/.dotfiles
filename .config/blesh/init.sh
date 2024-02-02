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
ble-face -s argument_error bg=red
ble-face -s argument_option fg=#f08080,italic
ble-face -s auto_complete fg=#5b5e5a,italic
ble-face -s command_alias fg=blue
ble-face -s command_builtin fg=#ff9966
ble-face -s command_directory fg=#96c7ef,italic,underline
ble-face -s command_file fg=blue
ble-face -s command_function fg=blue
ble-face -s command_keyword fg=purple
ble-face -s disabled fg=#5b5e5a
ble-face -s filename_directory fg=#96c7ef,italic,underline
ble-face -s filename_directory_sticky fg=0,bg=green
ble-face -s filename_executable fg=green,bold
ble-face -s filename_ls_colors none
ble-face -s filename_orphan fg=cyan,bold,underline
ble-face -s filename_other none
ble-face -s region bg=#3a3d37
ble-face -s region_insert bg=#3a3d37
ble-face -s syntax_brace fg=#838781
ble-face -s syntax_command fg=blue
ble-face -s syntax_comment fg=#e2c792
ble-face -s syntax_delimiter fg=#838781
ble-face -s syntax_document fg=cyan,bold
ble-face -s syntax_document_begin fg=cyan,bold
ble-face -s syntax_error bg=red
ble-face -s syntax_escape fg=#f08080
ble-face -s syntax_expr fg=#c5c2ee
ble-face -s syntax_function_name fg=blue
ble-face -s syntax_glob fg=#ff9966
ble-face -s syntax_param_expansion fg=red
ble-face -s syntax_quotation fg=green
ble-face -s syntax_tilde fg=#c5c2ee
ble-face -s syntax_varname fg=none
ble-face -s varname_array fg=#ff9966
ble-face -s varname_empty fg=#ff9966
ble-face -s varname_export fg=#ff9966
ble-face -s varname_expr fg=#ff9966
ble-face -s varname_hash fg=#ff9966
ble-face -s varname_number fg=none
ble-face -s varname_readonly fg=#ff9966
ble-face -s varname_transform fg=#ff9966
ble-face -s varname_unset bg=red
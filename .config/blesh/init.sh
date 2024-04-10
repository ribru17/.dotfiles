#!/bin/bash

# vim-surround
ble-import lib/vim-surround

# copy to system clipboard
# shellcheck disable=2034,1007,2154
function ble/keymap:vi/operator:Y {
    local beg=$1 end=$2 context=$3 arg=$4 reg=$5
    local yank_type= yank_content=
    if [[ $context == line ]]; then
        ble_keymap_vi_operator_index=$_ble_edit_ind
        yank_type=L
        yank_content=${_ble_edit_str:beg:end-beg}
    elif [[ $context == block ]]; then
        local sub
        local -a afill=() atext=()
        for sub in "${sub_ranges[@]}"; do
            local sub4=${sub#*:*:*:*:}
            local sfill=${sub4%%:*} stext=${sub4#*:}
            ble/array#push afill "$sfill"
            ble/array#push atext "$stext"
        done

        IFS=$'\n' builtin eval 'local yank_content="${atext[*]-}"'
        local IFS=$_ble_term_IFS
        yank_type=B:"${afill[*]-}"
    else
        yank_type=
        yank_content=${_ble_edit_str:beg:end-beg}
    fi

    echo -n "$yank_content" | wl-copy 2>/dev/null
    ble/keymap:vi/mark/commit-edit-area "$beg" "$end"
    return 0
}

blehook/eval-after-load keymap_vi "
  ble-bind -m vi_nmap -f 'C-y' 'vi-command/operator Y'
  ble-bind -m vi_omap -f 'C-y' 'vi-command/operator Y'
  ble-bind -m vi_xmap -f 'C-y' 'vi-command/operator Y'
"

# suppress error output
bleopt complete_ambiguous=
bleopt complete_auto_history=
bleopt exec_errexit_mark=''
bleopt prompt_eol_mark=''
bleopt term_index_colors=auto
bleopt exec_elapsed_mark=''

ble-bind -f 'C-SP' 'complete show_menu'
ble-bind -m auto_complete -f 'C-e' auto_complete/cancel
ble-bind -m isearch -f 'RET' isearch/accept-line
ble-bind -m isearch -f 'C-m' isearch/accept-line
ble-bind -m vi_imap -f 'C-c' discard-line
ble-bind -m vi_nmap -f 'C-c' discard-line
ble-bind -m vi_imap -f 'C-RET' accept-line
ble-bind -m vi_imap -f 'S-RET' newline
ble-bind -m vi_nmap -f 'S-RET' accept-line
ble-bind -m vi_nmap -f 'H' vi-command/beginning-of-line
ble-bind -m vi_omap -f 'H' vi-command/beginning-of-line
ble-bind -m vi_xmap -f 'H' vi-command/beginning-of-line
ble-bind -m vi_nmap -f 'L' vi-command/forward-eol
ble-bind -m vi_omap -f 'L' vi-command/forward-eol
ble-bind -m vi_xmap -f 'L' vi-command/forward-eol
ble-bind -m emacs -f 'S-RET' newline
# for kitty
ble-bind -m auto_complete -f C-i auto_complete/insert
ble-bind -m emacs -f 'M-DEL' kill-backward-fword
ble-bind -m vi_imap -f 'M-DEL' kill-backward-fword
# for wezterm
ble-bind -m auto_complete -f TAB auto_complete/insert
ble-bind -m emacs -f 'M-C-?' kill-backward-fword
ble-bind -m vi_imap -f 'M-C-?' kill-backward-fword

# colors
# shellcheck disable=SC1091
source "$HOME/.config/blesh/themes/bamboo_multiplex.sh"

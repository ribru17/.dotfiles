#
# ~/.bash_profile
#

# if on wayland, run firefox with wayland mode enabled
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    export MOZ_DBUS_REMOTE=1
    export MOZ_ENABLE_WAYLAND=1
fi

[[ -f ~/.bashrc ]] && . ~/.bashrc

if [ $2 == "0" ]; then
    hyprctl dispatch movetoworkspacesilent $1
else
    hyprctl dispatch movetoworkspace $1
fi
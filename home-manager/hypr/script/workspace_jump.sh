#!/bin/bash

ANIMATION="vert_menu"

if [ "$1" == "1" ]; then
    OFFSET=10
else
    OFFSET=-10
fi

currentWS=$(hyprctl activeworkspace -j | jq '.id')
targetWS=$((currentWS + OFFSET))

# アニメーションの設定（上向き/下向き）
if [ "$1" == "1" ]; then
    hyprctl keyword animation "workspaces, 1, 14, $ANIMATION, slidevert"
else
    hyprctl keyword animation "workspaces, 1, 14, $ANIMATION, slidevert"
fi

hyprctl dispatch workspace "$targetWS"

hyprctl keyword animation "workspaces, 1, 7, menu_decel, slide"

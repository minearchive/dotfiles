#!/bin/bash

currentWS=$(hyprctl activeworkspace -j | jq '.id')
targetWS=$((currentWS + 10))

hyprctl keyword animation "workspaces, 1, 14, vert_menu, slidevert"
hyprctl dispatch workspace "$targetWS"
hyprctl keyword animation "workspaces, 1, 7, menu_decel, slide"

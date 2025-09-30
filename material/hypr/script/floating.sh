#!/usr/bin/env bash

# Usage: floating.sh [window_class] [width] [height] [float] [center]
# Example: floating.sh "kitty" 800 600 true true

window_class=${1:-""}
width=${2:-800}
height=${3:-600}
float=${4:-true}
center=${5:-true}

# Check if window class is provided
if [ -z "$window_class" ]; then
    echo "Usage: $0 <window_class> [width] [height] [float] [center]"
    echo "Example: $0 kitty 800 600 true true"
    exit 1
fi

# Apply floating rule
if [ "$float" = "true" ]; then
    hyprctl keyword windowrulev2 "float, class:^($window_class)$"
    echo "Applied floating rule for $window_class"
fi

# Apply size rule
hyprctl keyword windowrulev2 "size $width $height, class:^($window_class)$, floating:1"
echo "Applied size rule: ${width}x${height} for $window_class"

# Apply centering rule
if [ "$center" = "true" ]; then
    hyprctl keyword windowrulev2 "center, class:^($window_class)$"
    echo "Applied centering rule for $window_class"
fi

echo "Window rules applied successfully for $window_class"
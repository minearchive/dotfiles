pragma Singleton
import QtQuick

//THIS IS A BLUE THEMED EXAMPLE MATERIAL COLOR PALETTE

QtObject {
    // Primary Colors
    readonly property color primary: "#b2c5ff"
    readonly property color primary_fixed: "#dae2ff"
    readonly property color primary_fixed_dim: "#b2c5ff"
    readonly property color on_primary: "#172e60"
    readonly property color on_primary_fixed: "#001847"
    readonly property color on_primary_fixed_variant: "#304578"
    readonly property color primary_container: "#304578"
    readonly property color on_primary_container: "#dae2ff"

    // Secondary Colors
    readonly property color secondary: "#c0c6dd"
    readonly property color secondary_fixed: "#dce2f9"
    readonly property color secondary_fixed_dim: "#c0c6dd"
    readonly property color on_secondary: "#2a3042"
    readonly property color on_secondary_fixed: "#151b2c"
    readonly property color on_secondary_fixed_variant: "#404659"
    readonly property color secondary_container: "#404659"
    readonly property color on_secondary_container: "#dce2f9"

    // Tertiary Colors
    readonly property color tertiary: "#e1bbdd"
    readonly property color tertiary_fixed: "#fed7f9"
    readonly property color tertiary_fixed_dim: "#e1bbdd"
    readonly property color on_tertiary: "#412741"
    readonly property color on_tertiary_fixed: "#2b122b"
    readonly property color on_tertiary_fixed_variant: "#5a3d59"
    readonly property color tertiary_container: "#5a3d59"
    readonly property color on_tertiary_container: "#fed7f9"

    // Error Colors
    readonly property color error: "#ffb4ab"
    readonly property color on_error: "#690005"
    readonly property color error_container: "#93000a"
    readonly property color on_error_container: "#ffdad6"

    // Surface & Background Colors
    readonly property color surface: "#121318"
    readonly property color on_surface: "#e2e2e9"
    readonly property color on_surface_variant: "#c5c6d0"
    readonly property color surface_dim: "#121318"
    readonly property color surface_bright: "#38393f"
    readonly property color surface_container_lowest: "#0d0e13"
    readonly property color surface_container_low: "#1a1b21"
    readonly property color surface_container: "#1e1f25"
    readonly property color surface_container_high: "#282a2f"
    readonly property color surface_container_highest: "#33343a"

    // Inverse Colors
    readonly property color inverse_surface: "#e2e2e9"
    readonly property color inverse_on_surface: "#2f3036"
    readonly property color inverse_primary: "#485d92"

    // Other Colors
    readonly property color outline: "#8f909a"
    readonly property color outline_variant: "#45464f"
    readonly property color shadow: "#000000"
    readonly property color scrim: "#000000"
}
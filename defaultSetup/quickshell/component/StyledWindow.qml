
// This comoponent is a skid.
// original one is https://github.com/caelestia-dots/shell/blob/ca1d9f2134d53329dd8583d8a506c7f99e5278c7/components/containers/StyledWindow.qml#L4

import Quickshell
import Quickshell.Wayland

PanelWindow {
    required property string title

    WlrLayershell.namespace: `mywaybar-${title}`
    color: "transparent"
}
import QtQuick
import QtQuick.Controls
import Quickshell.Hyprland
import "../theme"

Rectangle {
    width: Math.min(300, windowTitle.implicitWidth + 20)
    height: 25
    radius: 8
    color: Colors.surface_variant
    visible: false // Hyprland.activeWindow.title !== "" --- IGNORE ---
    
    Text {
        id: windowTitle
        // text: Hyprland.activeWindow.title || ""
        color: Colors.on_surface
        anchors.centerIn: parent
        elide: Text.ElideRight
        width: parent.width - 16
        font.pixelSize: 12
    }
}

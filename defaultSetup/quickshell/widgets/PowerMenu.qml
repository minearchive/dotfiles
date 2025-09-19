import QtQuick
import QtQuick.Controls
import Quickshell.Hyprland
import "../theme"

Rectangle {
    width: 25
    height: 25
    radius: 8
    color: Colors.error_container
    
    Text {
        text: "󰐥"
        font.pixelSize: 16
        color: Colors.on_error_container
        anchors.centerIn: parent
    }
    
    MouseArea {
        anchors.fill: parent
        onClicked: {
            Hyprland.dispatchKeyword("exec", "wlogout")
        }
    }
}

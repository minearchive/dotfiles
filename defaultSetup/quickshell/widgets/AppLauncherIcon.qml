import QtQuick
import QtQuick.Controls
import Quickshell.Hyprland
import "../theme"

Rectangle {
    width: 25
    height: 25
    color: Colors.primary
    radius: 12
    
    Text {
        text: "󱄅"
        font.pixelSize: 20
        color: Colors.on_primary
        anchors.centerIn: parent
        width: 17
        height: 32
    }
    
    MouseArea {
        anchors.fill: parent
        onClicked: {
        }
    }
}

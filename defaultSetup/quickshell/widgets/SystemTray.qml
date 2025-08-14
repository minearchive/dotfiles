import QtQuick
import QtQuick.Controls
import "../Theme"

Rectangle {
    width: 25
    height: 25
    radius: 8
    color: Colors.surface_variant
    
    Text {
        text: "󰍉"
        font.pixelSize: 16
        color: Colors.on_surface
        anchors.centerIn: parent
    }
    
    MouseArea {
        anchors.fill: parent
        onClicked: {
            // Toggle system tray or notifications
        }
    }
}

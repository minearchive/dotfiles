import QtQuick
import QtQuick.Controls
import "../theme"

 import Quickshell.Bluetooth 

Rectangle {
    width: 50
    height: 25
    radius: 8
    color: Colors.surface_variant

    id: root

    Row {
        anchors.centerIn: parent
        anchors.verticalCenter: parent.verticalCenter
        spacing: 4
        Text {
            text: "󰤨"
            font.pixelSize: 14
            color: Colors.on_surface
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: {
                if (root.active) {
                    return root.active ? root.active.name : "?"
                }
                return "󰂯"
            }
            font.pixelSize: 16
            color: Colors.on_surface
        }
    }
}

import QtQuick
import QtQuick.Controls
import "../theme"

Rectangle {
    width: 25
    height: 25
    radius: 8
    color: Colors.surface_variant
    
    Row {
        anchors.centerIn: parent
        spacing: 4
        
        Text {
            text: "󰤨"
            font.pixelSize: 14
            color: Colors.on_surface
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}

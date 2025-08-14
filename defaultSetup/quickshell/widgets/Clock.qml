import QtQuick
import QtQuick.Controls
import "../Theme"

Rectangle {
    width: 120
    height: 25
    radius: 8
    color: Colors.primary
    
    Text {
        id: clockText
        anchors.centerIn: parent
        color: Colors.on_primary
        font.pixelSize: 12
        font.weight: Font.Medium
    }
    
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            clockText.text = new Date().toLocaleTimeString(Qt.locale(), "hh:mm:ss")
        }
    }
    
    MouseArea {
        anchors.fill: parent
        onClicked: {
            // Open calendar or time settings
        }
    }
}

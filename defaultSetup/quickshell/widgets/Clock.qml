import QtQuick
import QtQuick.Controls
import "../theme"

Rectangle {
    width: 120
    height: 25
    radius: 8
    color: Colors.primary

    Text {
        id: clockText
        anchors.centerIn: parent
        color: Colors.on_primary
        font.pixelSize: 14
        font.weight: 600
        font.family: Fonts.noto
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

import QtQuick
import Quickshell
import Quickshell.Io

import "root:/theme"
import "root:/config"

Rectangle {
    id: clockBackground
    color: Colors.primary
    radius: 20

    width: 100
    height: 25

    Text {
        id: clockText
        anchors.centerIn: parent

        color: Colors.on_primary
        font.pixelSize: 20
        font.weight: Font.Bold
        text: Qt.formatTime(new Date(), "hh:mm")
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            clockText.text = Qt.formatTime(new Date(), "hh:mm")
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            Quickshell.execDetached(["gnome-clocks",])
        }
    }
}

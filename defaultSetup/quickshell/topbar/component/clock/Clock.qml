import QtQuick
import Quickshell
import Quickshell.Io

import "../../../theme"
import "../../../config"

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

    MouseArea {
        anchors.fill: parent
        onClicked: {
            Quickshell.execDetached(["gnome-clocks",])
        }
    }
}
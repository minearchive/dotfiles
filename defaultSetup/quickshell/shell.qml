import QtQuick
import QtQuick.Controls
import Quickshell

import Quickshell.Services.UPower
import "Theme"

ShellRoot {

    ReloadPopout { }

    PanelWindow {
        anchors {
            top: true
            left: true
            right: true
        }
        color: Colors.surface

        Row {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 20

            Rectangle {
                width: 25
                color: Colors.surface_container_high
                radius: 5
                height: 25
            }
        }
        implicitHeight: 35
    }
}

import QtQuick
import QtQuick.Controls
import Quickshell
import "Theme"

ShellRoot {
    PanelWindow {
        anchors {
            top: true
            left: true
            right: true
        }

        color: Colors.surface

        Row {
            spacing: 10

            Rectangle {
                width: 30
                height: 30
                radius: 5
                color: Colors.primary
                border.color: Colors.outline
            }
        }

        implicitHeight: 35
    }
}

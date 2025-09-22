import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland

import "../config"
import "../component"
import "../theme"
import "workspace"

Variants {
        model: Quickshell.screens
    Scope {
        id: screenScope
        required property ShellScreen modelData

        StyledWindow {
            title: "topbar"

            color: Colors.background

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 30

            Row {
                id: layout
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                Rectangle {
                    width: 180
                    height: 20
                    radius: 15
                    color: Colors.primary

                    Workspace { }
                }

            }
        }
    }
}
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland

import "../config"
import "../component"
import "../theme"
import "workspace"
import "media"
import "other"

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

            implicitHeight: 40

            Row {
                id: left
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 10

                Rectangle {
                    width: 180
                    height: 20
                    radius: 15
                    color: Colors.primary

                    Workspace { }
                }
            }

            Row {
                id: center
                anchors.centerIn: parent
                spacing: 10

                MediaPlayer { }
            }
        }

        VolumeNotification { }
        SystemNotification { }
        // ActivateLinux { }
    }
}
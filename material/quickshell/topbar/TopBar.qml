import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland

import "../config"
import "../component"
import "../theme"
import "workspace"
import "component/media"
import "component/popup"
import "component/clock"

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

                Workspace { }
            }

            Row {
                id: center
                anchors.centerIn: parent
                anchors.horizontalCenter: parent.horizontalCenter

                // MediaPlayer { }
            }

            Row {
                id: right
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 10

                Clock { }
            }
        }

        VolumeNotification { }
        // SystemNotification { }
        // ActivateLinux { }
    }
}

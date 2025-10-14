import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland

import "../config"
import "../component"
import "../theme"
import "workspace"
import "component"

Variants {
        model: Quickshell.screens
    Scope {
        id: screenScope
        required property ShellScreen modelData

        StyledWindow {
            title: "topbar"

            color: "transparent"

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 500
            exclusiveZone: 40

            Rectangle {
                id: mask_region

                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                }

                implicitWidth: parent.width
                implicitHeight: 40
                color: Colors.background
            }

            mask: Region {
                item: mask_region
                Region {
                    item: mediaPlayer.container
                }
            }

            Rectangle {
                // set center in parent
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                    topMargin: 5
                }

                implicitWidth: parent.width
                implicitHeight: 35
                color: Colors.background

                Row {
                    id: left
                    anchors.top: parent.top
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 10

                    Workspace { }
                }

                Row {
                    id: center
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter

                    MediaPlayer {
                        id: mediaPlayer
                    }
                }

                Row {
                    id: right
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: 10

                    Clock { }
                    Hardware { }
                }
            }

            VolumeNotification { }
            // SystemNotification { }
            // ActivateLinux { }
        }
    }
}

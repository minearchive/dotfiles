import QtQuick
import Quickshell
import Quickshell.Hyprland

import "../../theme"
import "../../config"

Rectangle {
    width: 180
    height: 25
    radius: 15
    color: Colors.primary
    Row {
        id: layout
        spacing: 5

        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Repeater {
            model: 10

            delegate: Rectangle {
                id: workspaceIndicator
                width: ((Hyprland.focusedWorkspace.id === groupStart + index + 1) ? 20 : 10)
                height: 12
                radius: 10
                property int groupStart: Math.floor((Hyprland.focusedWorkspace.id - 1) / 10) * 10
                property int groupEnd: groupStart + 9

                color: (Hyprland.focusedWorkspace.id === groupStart + index + 1)
                    ? Colors.on_primary
                    : Colors.on_primary_container

                Behavior on width {
                    NumberAnimation { duration: Appearance.animation.durations.large; easing.type: Easing.OutExpo }
                }

                Behavior on color {
                    ColorAnimation { duration: Appearance.animation.durations.medium; easing.type: Easing.OutExpo }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        Hyprland.dispatch(`workspace ${groupStart + index + 1}`);
                    }
                }
        }
        }
    }
}
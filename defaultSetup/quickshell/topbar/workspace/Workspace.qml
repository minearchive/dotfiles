import QtQuick
import Quickshell
import Quickshell.Hyprland

import "../../theme"
import "../../config"

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
            height: 10
            radius: 10
            property int groupStart: Math.floor((Hyprland.focusedWorkspace.id - 1) / 10) * 10
            property int groupEnd: groupStart + 9

            color: (Hyprland.focusedWorkspace.id === groupStart + index + 1)
                ? Colors.primary_container
                : Colors.on_primary_container

            Behavior on width {
                NumberAnimation { duration: Appearance.animation.durations.extraLarge; easing.type: Easing.OutQuint }
            }

            Behavior on color {
                ColorAnimation { duration: 500; easing.type: Easing.OutQuint }
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
import QtQuick
import QtQuick.Controls
import Quickshell.Hyprland
import "../Theme"

Rectangle {
    id: workspaces
    radius: 8
    color: Colors.on_surface
    width: 200
    height: 25
    
    Row {
        anchors.centerIn: parent
        spacing: 6
        
        Repeater {
            model: Hyprland.workspaces
            delegate: Rectangle {
                radius: 5;
                width: model.id === Hyprland.focusedWorkspace.id ? 48 : (model.windows > 0 ? 32 : 8)
                height: 12
                color: model.id === Hyprland.focusedWorkspace.id ? Colors.primary : (model.windows > 0 ? Colors.secondary : Colors.outline)
                border.width: model.active ? 2 : 0
                border.color: Colors.on_primary
                
                Behavior on width {
                    NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        Hyprland.dispatchWorkspace(model.id)
                    }
                }
            }
        }
    }
}

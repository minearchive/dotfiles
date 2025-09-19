import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Services.UPower
import Quickshell.Hyprland
import "theme"
import "widgets"
import "popup"

ShellRoot {
    ReloadPopout { }
    
    PanelWindow {
        anchors {
            top: true
            left: true
            right: true
        }
        color: Colors.surface
        implicitHeight: 45
        
        // Left section
        Row {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            spacing: 10
            
            // Left spacing
            Rectangle {
                width: 10
                height: 1
                color: Colors.surface
            }
            
            // App launcher icon
            AppLauncherIcon {}
            
            // Workspaces
            Workspaces {}
            
            // Active window title
            WindowTitle {}
        }

        // Center section
        Row {
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10
            // Empty for now
            MediaPlayer { }
        }
        
        // Right section
        Row {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 10
            spacing: 10
            
            SystemTray {}
            Volume {}
            Battery {}
            Clock {}
            PowerMenu {}
        }
    }
}
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Services.UPower
import Quickshell.Hyprland
import "Theme"
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
        implicitHeight: 35
        
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
        
        // Right section
        Row {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 10
            spacing: 10
            
            SystemTray {}
            NetworkStatus {}
            Volume {}
            Battery {}
            Clock {}
            PowerMenu {}
        }
    }
}
import QtQuick
import Quickshell

import Quickshell.Services.Notifications

import "../../../theme"
import "../../../config"
import "../../../component"

import "../notifications"

Scope {
    id: root

    LazyLoader {
        id: systemNotificationLoader
        active: true
    
        PanelWindow {

            color: "transparent"

            mask: Region { } 

            anchors {
                top: true
                right: true
            }

            Text {
                color: Colors.background
            }
        }
    }
}
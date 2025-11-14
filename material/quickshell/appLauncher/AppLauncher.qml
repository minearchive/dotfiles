import QtQuick
import Quickshell

import "root:/theme"
import "root:/config"
import "root:/component"

Scope {
    id: launcherScope

    property bool shown: false

    //window 
    StyledWindow {
        id: window
        color: Colors.background

        implicitHeight: 600
        implicitWidth: 500

        visible: launcherScope.shown

        Column {
            Rectangle {
                width: window.implicitHeight
                color: "white"
            }
        }
    }
}
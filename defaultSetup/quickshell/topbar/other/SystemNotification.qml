import QtQuick
import Quickshell

Scope {
    LazyLoader {
        id: systemNotificationLoader
        active: true

        PanelWindow {
            anchors {
                right: true
                top: true
            }

            color: "transparent"

            margins.top: 10
            margins.right: 10

            implicitWidth: 300
            implicitHeight: 50

            exclusiveZone: 0
        }
    }
}
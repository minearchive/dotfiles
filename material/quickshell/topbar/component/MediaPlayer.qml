import QtQuick
import Quickshell

import "../../theme"
import "../../config"

Scope {
    id: root

    Loader {
        id: mediaPlayerLoader
        active: true

        sourceComponent: PanelWindow {
            id: window

            anchors {
                top: true
            }

            // mask: Region { }

            color: "transparent"

            implicitWidth: 200
            implicitHeight: 40

            exclusiveZone: 0

            Rectangle {
                id: background

                anchors.fill: parent

                color: Colors.primary
                radius: 20

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        console.log("clicked");
                        window.expanding = !window.expanding;
                    }
                }
            }
        }
    }

    Timer {
        interval: 2000
        running: false
        repeat: true
        onTriggered: {
            mediaPlayerLoader.active = !mediaPlayerLoader.active;
        }
    }
}

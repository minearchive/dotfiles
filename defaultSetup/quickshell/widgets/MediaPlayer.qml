import QtQuick
import QtQuick.Controls
import Quickshell.Services.Mpris 
import Quickshell

import "../theme"

Rectangle {
    width: expanded ? expanded_w: 200
    height: expanded ? expanded_h: 25
    radius: 8
    color: Colors.on_surface

    property bool expanded: false
    property int expanded_w: 400
    property int expanded_h: 150

    id: root

    Text {
        text: {
            return root.active ? root.active.name : "No player"
        }
        font.family: Fonts.noto
        font.weight: 650
        font.pixelSize: 14
        color: Colors.surface_variant
        anchors.centerIn: parent
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.expanded = !root.expanded
            console.log("Mouse area clicked")
            medialoader.active = root.expanded
            medialoader.loading = root.expanded
        }
    }

    LazyLoader {
        id: medialoader
        PanelWindow {
            anchors {
                top: true
            }

            Rectangle {

            }
        }
    }   
}
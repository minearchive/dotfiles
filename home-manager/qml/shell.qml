import QtQuick
import QtQuick.Controls
import Quickshell

ShellRoot {
    //top
    PanelWindow {
        anchors {
            top: true
            left: true
            right: true
        }
        height: 30
        color: "#445E91"

        Row {
            anchors.fill: parent
            spacing: 16
            padding: 8
        }
    }

    //bottom
    PanelWindow {
        anchors {
            bottom: true
            left: true
            right: true
        }
	height: 15
        color: "#b6e9ff"

        Row {
            anchors.fill: parent
            spacing: 16
            padding: 8
        }
    }

    //bottom
    PanelWindow {
        anchors {
            left: true
            top:true
            bottom: true
        }
        width: 15
        color: "#b6e9ff"

        Row {
            anchors.fill: parent
            spacing: 16
            padding: 8
        }
    }
}

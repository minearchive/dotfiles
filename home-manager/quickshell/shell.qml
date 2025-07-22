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

            // 左: ロゴやワークスペース名
            Text {
                text: "Workspace"
                color: "white"
                font.pointSize: 14
            }
            // 中央: 時計
            Item {
                anchors.horizontalCenter: parent.horizontalCenter
                width: 120; height: 30
                Timer {
                    id: clockTimer
                    interval: 1000; running: true; repeat: true
                    onTriggered: clock.text = Qt.formatDateTime(new Date(), "hh:mm:ss")
                }
                Text {
                    id: clock
                    text: Qt.formatDateTime(new Date(), "hh:mm:ss")
                    color: "white"
                    font.pointSize: 14
                    anchors.centerIn: parent
                }
            }
            // 右: システム情報（例: CPU, RAM）
            Text {
                text: "CPU: 10% | RAM: 40%"
                color: "white"
                font.pointSize: 12
                anchors.right: parent.right
            }
        }
    }

    // PanelWindow {
        // anchors {
            // top: true
            // left: true
            // right: true
            // bottom: true
        // }

        

        // color: "transparent"
    // }
}

import QtQuick
import Quickshell

import "../../theme"
import "../../config"

Rectangle {
    property bool expand: false
    property alias container: mediaPlayerContainer

    id: mediaPlayerContainer

    height: 25
    width: mediaPlayerText.width + 40

    radius: 13 // half of height for rounded corners

    color: Colors.primary

    Text {
        id: mediaPlayerText

        anchors {
            horizontalCenter: parent.horizontalCenter
        }

        text: {
            let content = "the greatest anime lover vs hyperflip enjoyer"
             return content.length > 30
        ? content.slice(0, 30) + "..."
        : content
        }
        color: Colors.on_primary
        font.pixelSize: 16
        font.weight: Font.Medium
        opacity: 1
        elide: Text.ElideRight
        
        Behavior on opacity {
            NumberAnimation {
                duration: 250
                easing.bezierCurve: [0,0.554,0,0.977, 1, 1]
            }
        }
    }

    MouseArea {
        anchors.fill: parent

        onPressed: {
            console.log("pressed");
            mediaPlayerContainer.expand = !mediaPlayerContainer.expand;
            mediaPlayerContainer.height = mediaPlayerContainer.expand ? 200: 25
            mediaPlayerContainer.width = mediaPlayerContainer.expand ? 415: mediaPlayerText.width + 40
            mediaPlayerText.opacity = mediaPlayerContainer.expand ? 0 : 1
        }        
    }

    Behavior on width {
        NumberAnimation {
            duration: Appearance.animation.durations.medium
            easing.bezierCurve: [0,0.554,0,0.977, 1, 1]
        }
    }

    Behavior on height {
        NumberAnimation {
            duration: Appearance.animation.durations.medium - 50
            easing.bezierCurve: [0,0.554,0,0.977, 1, 1]
        }
    }
}
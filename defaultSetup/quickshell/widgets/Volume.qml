import QtQuick
import QtQuick.Controls
import Quickshell.Hyprland

import Quickshell.Services.Pipewire

import "../Theme"

Rectangle {
    width: 60
    height: 25
    radius: 8
    color: Colors.surface_variant
    
    Row {
        anchors.centerIn: parent
        spacing: 4
        
        Text {
            text: {
                const device = Pipewire.defaultAudioSink;
                if (!device) return ""; // No audio device available
                console.log("Volume:", device.audio);
            }
            font.pixelSize: 14
            color: Colors.on_surface
            anchors.verticalCenter: parent.verticalCenter
        }
        
        Text {
            text: "75%"
            font.pixelSize: 10
            color: Colors.on_surface
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    
    MouseArea {
        anchors.fill: parent
        onClicked: {
            Hyprland.dispatchKeyword("exec", "pavucontrol")
        }
    }
}

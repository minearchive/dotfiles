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

    PwObjectTracker {
        objects: [ Pipewire.defaultAudioSink ]
    }
    
    Row {
        anchors.centerIn: parent
        spacing: 4
        
        Text {
            text: {
                const sink = Pipewire.defaultAudioSink
                const volume = sink.audio.volume
                if (volume == 0) {
                    return ""
                }

                if (volume > 0 && volume < 20) {
                    return ""
                }
                if (volume <= 20) {
                    return ""
                }
                return "w"
            }
            font.pixelSize: 14
            color: Colors.on_surface
            anchors.verticalCenter: parent.verticalCenter
        }
        
        Text {
            text: {
                const sink = Pipewire.defaultAudioSink
                const volume = sink.audio.volume
                return volume + "%"
            }
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

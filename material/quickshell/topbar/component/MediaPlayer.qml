import QtQuick
import Quickshell
import Quickshell.Widgets

import "root:/theme"
import "root:/config"
import "root:/service"

Rectangle {
    property bool expand: false
    property alias container: mediaPlayerContainer

    function getW() {
        return mediaPlayerText.width + 40;
    }
    
    id: mediaPlayerContainer

    height: 25
    width: {
        return expand ? 415 : getW();
    }

    ClippingWrapperRectangle {
        radius: 13
        color: "transparent"
        anchors.fill: parent

        Image {
            id: music
            fillMode: Image.PreserveAspectCrop
            source: {
                let player = MprisState.getPlayer();
                if (!player) return "";
                return player.trackArtUrl || "";
            }
            opacity: 0
            clip: true
            anchors.fill: parent


            Behavior on opacity {
                NumberAnimation {
                    duration: Appearance.animation.durations.expressive_default_effects
                    easing.type: Easing.OutCirc
                }
            }
            sourceSize.height: mediaPlayerContainer.height
            sourceSize.width: mediaPlayerContainer.width
        }
    }

    Rectangle {
        //progress bar

    }

    radius: 13 // half of height for rounded corners

    color: Colors.primary
    
    Text {
        id: mediaPlayerText
        x: 20
        y: 0

        text: {
            let player = MprisState.getPlayer();
            if (!player) return "Nothing Playing";
            let content = "";
            let title = player.trackTitle || "Unknown Title";
            let artist = player.trackArtist ? player.trackArtist : "?";
            content = title + " - " + artist;
            return content.length > 30
            ? content.slice(0, 30) + "..."
            : content;
        }
        color: Colors.on_primary 
        font.pixelSize: 16
        font.weight: Font.Medium
        opacity: 1
        elide: Text.ElideRight

        transform: Scale {
            id: mediaPlayerTextScale
            origin.x: 0
            origin.y: 0
            xScale: mediaPlayerContainer.expand ? 1.2 : 1.0
            yScale: mediaPlayerContainer.expand ? 1.2 : 1.0

            Behavior on xScale {
                NumberAnimation {
                    duration: Appearance.animation.durations.expressive_fast_spatial
                    easing.type: Easing.OutCirc
                }
            }

            Behavior on yScale {
                NumberAnimation {
                    duration: Appearance.animation.durations.expressive_fast_spatial
                    easing.type: Easing.OutCirc
                }
            }
        }

        Behavior on x {
            NumberAnimation {
                duration: Appearance.animation.durations.expressive_fast_spatial
                easing.type: Easing.OutCirc
            }
        }
        
        Behavior on y {
            NumberAnimation {
                duration: Appearance.animation.durations.expressive_fast_spatial
                easing.type: Easing.OutCirc
            }
        }
        
        Behavior on opacity {
            NumberAnimation {
                duration: Appearance.animation.durations.expressive_default_effects
                easing.type: Easing.OutCirc
            }
        }
    }

    Text {
        id: artist
        text: "by Artist Name"
        color: Colors.on_background
        font.weight: Font.Medium
        font.pixelSize: 16
        x: 20
        y: 50
        opacity: 1
        visible: mediaPlayerContainer.expand
        Behavior on opacity {
            NumberAnimation {
                duration: Appearance.animation.durations.expressive_default_effects
                easing.type: Easing.OutCirc
            }
        }
    }

    MouseArea {
        anchors.fill: parent

        onPressed: {
            if (!MprisState.getPlayer()) return;
            return; // Disable toggling for now
            mediaPlayerContainer.expand = !mediaPlayerContainer.expand;
            
            if (mediaPlayerContainer.expand) {
                mediaPlayerContainer.height = 200;
                mediaPlayerContainer.width = 415;
                mediaPlayerText.x = 20;
                mediaPlayerText.y = 20;
                music.opacity = 1;
                mediaPlayerText.color = Colors.on_background;
            } else {
                mediaPlayerContainer.height = 25;
                mediaPlayerContainer.width = getW();
                mediaPlayerText.x = 20;
                mediaPlayerText.y = 0;
                music.opacity = 0;
                mediaPlayerText.color = Colors.on_primary;
            }
        }        
    }

    Behavior on width {
        NumberAnimation {
            duration: Appearance.animation.durations.expressive_fast_spatial
            easing.type: Easing.OutCirc
        }
    }

    Behavior on height {
        NumberAnimation {
            duration: Appearance.animation.durations.expressive_fast_spatial
            // easing.bezierCurve: Appearance.animation.easings.expressive_fast_spatial
            easing.type: Easing.OutCirc
        }
    }

    Behavior on radius {
        NumberAnimation {
            duration: Appearance.animation.durations.expressive_fast_spatial
            // easing.bezierCurve: Appearance.animation.easings.expressive_fast_spatial
            easing.type: Easing.OutCirc
        }
    }
}
import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Pipewire
import Quickshell.Wayland

import "root:/theme"
import "root:/config"

Scope {
    id: root

    property bool shouldShowOsd: false

    PwObjectTracker {
        objects: [ Pipewire.defaultAudioSink ]
    }

    Connections {
		target: Pipewire.defaultAudioSink?.audio

		function onVolumeChanged() {
			root.shouldShowOsd = true;
			hideTimer.restart();
		}

        function onMutedChanged() {
            root.shouldShowOsd = true;
            hideTimer.restart();
        }
	}

    Timer {
        id: hideTimer
        interval: 2000
        running: false
        onTriggered: {
            root.shouldShowOsd = false;
        }
    }

    LazyLoader {
        id: volumeNotificationLoader
        active: true

        PanelWindow {
            id: w
            anchors {
                top: true
            }

            color: "transparent"

            implicitWidth: 210
            implicitHeight: 35

            margins.top: 20

            mask: Region {
                item: Rectangle {
                    x: 0
                    y: 0
                    width: w.implicitWidth * background.scale
                    height: w.implicitHeight * background.scale
                    radius: 20 * background.scale

                    Behavior on width {
                        NumberAnimation { duration: Appearance.animation.durations.medium; easing.type: Easing.OutBack }
                    }

                    Behavior on height {
                        NumberAnimation { duration: Appearance.animation.durations.medium; easing.type: Easing.OutBack }
                    }

                    Behavior on radius {
                        NumberAnimation { duration: Appearance.animation.durations.medium; easing.type: Easing.OutBack }
                    }
                }
            }

            WlrLayershell.layer: WlrLayer.Overlay

            exclusiveZone: 0

            Rectangle {
                id: background

                anchors.fill: parent

                color: Colors.background
                radius: 20

                scale: root.shouldShowOsd ? 1 : 0.9

                Behavior on scale {
                    NumberAnimation { duration: Appearance.animation.durations.medium; easing.type: Easing.OutBack }
                }

                opacity: root.shouldShowOsd ? 1 : 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: Appearance.animation.durations.medium;
                        easing.type: Easing.OutQuint
                    }
                }

                Row {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 10

                    Rectangle {
                        id: volumeLevel
                        width: 140
                        height: 15
                        radius: 7
                        color: Colors.surface_variant
                        anchors.verticalCenter: parent.verticalCenter

                        Rectangle {
                            width: Math.min((Pipewire.defaultAudioSink?.audio?.muted ? 0 : (Pipewire.defaultAudioSink?.audio?.volume || 0)) * parent.width, parent.width)
                            height: parent.height
                            radius: parent.radius
                            color: Pipewire.defaultAudioSink?.audio.volume > 0.7 ? Colors.error : Colors.primary

                            Behavior on width {
                                NumberAnimation { duration: Appearance.animation.durations.medium; easing.type: Easing.OutQuint }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onPressed: event => {
                                if (Pipewire.defaultAudioSink && root.shouldShowOsd) {
                                    changePercent(event.x / parent.width);
                                }
                            }
                            hoverEnabled: true
                            onPositionChanged: event => {
                                if (Pipewire.defaultAudioSink && root.shouldShowOsd && event.buttons === Qt.LeftButton) {
                                    changePercent(event.x / parent.width);
                                }
                            }

                            function changePercent(perc) {
                                Pipewire.defaultAudioSink.audio.volume = perc;
                            }
                        }
                    }

                    Text {
                        id: volumePercent
                        text: Pipewire.defaultAudioSink?.audio?.muted ? "Mute" : Math.round((Pipewire.defaultAudioSink?.audio?.volume || 0) * 100) + "%"
                        font.pixelSize: 16
                        color: Colors.on_surface
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
    }
}

import QtQuick
import QtQuick.Layouts
import Quickshell

import "../Theme"

Scope {
	id: root
	property bool failed;
	property string errorString;

	Connections {
		target: Quickshell

		function onReloadCompleted() {
			Quickshell.inhibitReloadPopup();
			root.failed = false;
			popupLoader.loading = true;
		}

		function onReloadFailed(error: string) {
			Quickshell.inhibitReloadPopup();
			popupLoader.active = false;

			root.failed = true;
			root.errorString = error;
			popupLoader.loading = true;
		}
	}

	LazyLoader {
		id: popupLoader

		PanelWindow {
			id: popup

			anchors {
                right: true
                bottom: true
			}

			margins {
				bottom: 25
				right: 25
			}

			implicitWidth: rect.width
			implicitHeight: rect.height

			color: "transparent"

			Rectangle {
				id: rect
				color: failed ?  "#802020" : "#009020"

				implicitHeight: layout.implicitHeight + 50
				implicitWidth: layout.implicitWidth + 30

				MouseArea {
					id: mouseArea
					anchors.fill: parent
					onClicked: popupLoader.active = false

					hoverEnabled: true
				}

				ColumnLayout {
					id: layout
					anchors {
						top: parent.top
						topMargin: 20
						horizontalCenter: parent.horizontalCenter
					}

					Text {
						text: root.failed ? "Reload failed." : "Reloaded completed!"
						color: "white"
					}

					Text {
						text: root.errorString
						color: "white"
						visible: root.errorString != ""
					}
				}

				Rectangle {
					id: bar
					color: "#20ffffff"
					anchors.bottom: parent.bottom
					anchors.left: parent.left
					height: 20

					PropertyAnimation {
						id: anim
						target: bar
						property: "width"
						from: rect.width
						to: 0
						duration: failed ? 10000 : 800
						onFinished: popupLoader.active = false

						paused: mouseArea.containsMouse
					}
				}

				Component.onCompleted: anim.start()
			}
		}
	}
}
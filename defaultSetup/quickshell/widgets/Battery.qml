import QtQuick
import QtQuick.Controls
import Quickshell.Services.UPower
import "../Theme"

Rectangle {
    width: 70
    height: 25
    radius: 8
    color: Colors.surface_variant
    visible: UPower.displayDevice.isLaptopBattery
    
    Row {
        anchors.centerIn: parent
        spacing: 4
        
        Text {
            text: {
                if (!UPower.displayDevice.isLaptopBattery) return ""
                const percent = UPower.displayDevice.percentage * 100
                if (UPower.displayDevice.state == UPowerDeviceState.Charging) return "󰂄"
                if (percent > 90) return "󰁹"
                if (percent > 80) return "󰂂"
                if (percent > 70) return "󰂁"
                if (percent > 60) return "󰂀"
                if (percent > 50) return "󰁿"
                if (percent > 40) return "󰁾"
                if (percent > 30) return "󰁽"
                if (percent > 20) return "󰁼"
                if (percent > 10) return "󰁻"
                return "󰁺"
            }
            font.pixelSize: 14
            color: UPower.displayDevice.percentage < 20 ? Colors.error : Colors.on_surface
            anchors.verticalCenter: parent.verticalCenter
        }
        
        Text {
            text: Math.round(UPower.displayDevice.percentage * 100) + "%"
            font.pixelSize: 10
            color: UPower.displayDevice.percentage < 20 ? Colors.error : Colors.on_surface
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}

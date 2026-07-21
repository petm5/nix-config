import QtQuick
import Quickshell
import Quickshell.Services.UPower
import "IconUtils.js" as IconUtils
import "../components/"

Text {
    id: batteryIcon
    font.family: "Material Symbols Outlined"
    font.pixelSize: root.iconSize

    visible: UPower.displayDevice.isLaptopBattery

    property var chargingIcons: [
        "battery_charging_20",
        "battery_charging_20",
        "battery_charging_30",
        "battery_charging_50",
        "battery_charging_60",
        "battery_charging_80",
        "battery_charging_90",
        "battery_charging_full"
    ]

    property var dischargingIcons: [
        "battery_0_bar",
        "battery_1_bar",
        "battery_2_bar",
        "battery_3_bar",
        "battery_4_bar",
        "battery_5_bar",
        "battery_6_bar",
        "battery_full"
    ]
    
    text: {
        if (!UPower.displayDevice.isLaptopBattery) {
            batteryIcon.visible = false;
            return ""
        }
        batteryIcon.visible = true;
        if (UPower.onBattery) {
            if (UPower.displayDevice.percentage * 100 < 3) {
                return "battery_alert"
            }
            return IconUtils.getIcon(dischargingIcons, UPower.displayDevice.percentage)
        } else {
            if (UPower.displayDevice.state == UPowerDeviceState.FullyCharged) {
                return "battery_full"
            }
            return IconUtils.getIcon(chargingIcons, UPower.displayDevice.percentage)
            
        }
    }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true
    }

    function formatTime(seconds) {
        let hrs = Math.floor(seconds / 3600);
        let mins = Math.floor((seconds % 3600) / 60);
        // let secs = Math.floor(seconds % 60);

        let pad = (num) => String(num).padStart(2, '0');

        if (hrs > 0) {
            return `${hrs} h ${pad(mins)} min`;
        } else {
            return `${mins} min`;
        }
    }

    StyledToolTip {
        id: tooltip
        text: {
            if (UPower.onBattery) {
                if (!UPower.displayDevice.timeToEmpty) {
                    return "Discharging";
                }
                return `Empty in ${formatTime(UPower.displayDevice.timeToEmpty)}`
            } else {
                if (!UPower.displayDevice.timeToFull) {
                        return "Charging";
                    }
                return `Full in ${formatTime(UPower.displayDevice.timeToFull)}`
            }
        }
        visible: hoverArea.containsMouse && tooltip.text.length > 0
    }
}

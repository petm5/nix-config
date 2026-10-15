import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Networking
import "../components/"

ColumnLayout {
    spacing: 12
    Layout.fillWidth: true
    Layout.fillHeight: true

	property var net: Networking
    property var activeWifiDevice: {
        for (let i = 0; i < net.devices.values.length; i++) {
            let device = net.devices.values[i];

            if (device.type === DeviceType.Wifi) {
                return device;
            }
        }
        return null;
    }
    property bool hasWifiHardware: { !!activeWifiDevice }
    property bool wifiEnabled: hasWifiHardware && net.wifiEnabled
    property bool isInteracting: false

    onActiveWifiDeviceChanged: {
        if (!activeWifiDevice) return;
        activeWifiDevice.scannerEnabled = true;
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: 8

        Title {
            Layout.fillWidth: true
            text: "Wi-Fi"
        }

        IconButton {
            text: "wifi_add"

            ContextToolTip {
                text: "Add Network"
                visible: parent.hovered
            }

            onClicked: { console.error("TODO: Add network dialog") }
        }

        Switch {
            checkable: hasWifiHardware
            checked: wifiEnabled
            onClicked: net.wifiEnabled = checked
            spacing: 0

            ContextToolTip {
                text: wifiEnabled ? "Turn off Wi-Fi" : "Turn on Wi-Fi"
                visible: parent.hovered
            }
        }
    }

    Item {
        Layout.fillWidth: true
        height: 2

        // Scanning indicator
        // Rectangle {
        //     color: "blue"
        //     width: parent.width
        //     height: parent.height

        //     visible: activeWifiDevice?.scannerEnabled ?? false
        // }
    }

    Text {
        visible: !wifiEnabled
        text: hasWifiHardware ? "To see available networks, turn on Wi-Fi." : "Wi-Fi is not supported on this device."
    }

    Text {
        visible: wifiEnabled && activeWifiDevice?.networks.values.length == 0
        text: "Scanning for Wi-Fi networks..."
    }

    ScrollView {
        Layout.fillWidth: true
        Layout.fillHeight: true

        ListView {
            clip: true
            spacing: 8

            visible: wifiEnabled

            // model: ScriptModel {
            //     values: {
            //         [...activeWifiDevice?.networks.values].filter((x) => x != null).sort((a, b) => {
            //             if (a.connected !== b.connected) {
            //                 return b.connected - a.connected;
            //             }
            //             if (a.stateChanging !== b.stateChanging) {
            //                 return b.stateChanging - a.stateChanging
            //             }
            //             if (activeWifiDevice?.type === DeviceType.Wifi) {
            //                 return b.signalStrength - a.signalStrength
            //             }
            //         })
            //     }
            // }
            model: activeWifiDevice?.networks

            delegate: NetworkDelegate {
                width: parent?.width
            }
        }
    }

}

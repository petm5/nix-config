import QtQuick
import Quickshell
import Quickshell.Networking
import "IconUtils.js" as IconUtils
import "../components/"

Icon {
    id: networkIcon

    property var net: Networking
    property bool connected: false
    property string networkName: ""

    property var wifiIcons: [
        "network_wifi_1_bar",
        "network_wifi_2_bar",
        "network_wifi_3_bar",
        "network_wifi"
    ]

    text: {
        let hasWiredConnection = false;
        let hasWifiHardware = false;
        let activeWiredDevice = null;
        let activeWifiDevice = null;

        if (net.devices.values.length == 0) {
            networkIcon.visible = false;
            return "";
        }

        networkIcon.visible = true;

        for (let i = 0; i < net.devices.values.length; i++) {
            let device = net.devices.values[i];
            
            if (device.type === DeviceType.Wired) {
                if (device.connected || (device.hasLink !== undefined && device.hasLink)) {
                    hasWiredConnection = true;
                    activeWiredDevice = device;
                }
            }

            if (device.type === DeviceType.Wifi && !hasWifiHardware) {
                hasWifiHardware = true;
                activeWifiDevice = device;
            }
        }

        if (hasWiredConnection) {
            networkIcon.connected = true;
            let network = activeWiredDevice.networks.values.find((network) => network.connected);
            networkIcon.networkName = network?.name || "";
            return "settings_ethernet";
        }

        if (!hasWifiHardware) {
            networkIcon.connected = false;
            return "globe_2_question";
        }

        if (activeWifiDevice.connected) {
            let network = activeWifiDevice.networks.values.find((network) => network.connected);
            networkIcon.networkName = network?.name || "";
            if (network) {
                networkIcon.connected = true;
                let strength = network.signalStrength;
                return IconUtils.getIcon(wifiIcons, strength);
            }
        }

        networkIcon.connected = false;

        switch (activeWifiDevice.state) {
            case ConnectionState.Unknown:
                return "signal_wifi_off";
            default:
                return "wifi_find";
        }
    }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true
    }

    StyledToolTip {
        id: tooltip
        text: connected ? `Connected (${networkName})` : "Disconnected";
        visible: hoverArea.containsMouse
    }
}

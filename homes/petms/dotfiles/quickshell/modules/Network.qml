import QtQuick
import Quickshell
import Quickshell.Networking
import "IconUtils.js" as IconUtils
import "../components/"

Text {
	id: networkIcon

	property var net: Networking
	property bool connected: false
	property string networkName: ""

	property var wifiIcons: [
		"network_wifi_0_bar",
		"network_wifi_1_bar",
		"network_wifi_2_bar",
		"network_wifi_3_bar",
        "signal_wifi_4_bar"
    ]

    function getNetworkStatus() {
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

        if (activeWifiDevice?.connected) {
        	networkIcon.connected = true;
        	let network = activeWifiDevice.networks.values.find((network) => network.connected);
        	networkIcon.networkName = network?.name || "";
        	if (network) {
            	let strength = network.signalStrength;
            	return IconUtils.getIcon(wifiIcons, strength);
            } else {
            	return "wifi_find"
            }
        }

    	networkIcon.connected = false;
        return "signal_wifi_off";
    }

    font.family: "Material Symbols Outlined"
    font.pixelSize: root.iconSize

    text: getNetworkStatus()

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

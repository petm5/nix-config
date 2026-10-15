import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Networking
import "../components/"
import "../modules/IconUtils.js" as IconUtils

ItemDelegate {
    required property Network modelData

    property bool needsAuth: {
        switch (modelData?.security) {
            case WifiSecurityType.Open:
            case WifiSecurityType.Unknown:
            case WifiSecurityType.Owe:
                return false
            default:
                return true
        }
    }

	property var wifiIcons: [
		"network_wifi_1_bar",
		"network_wifi_2_bar",
		"network_wifi_3_bar",
        "network_wifi"
    ]

	property var wifiIconsLocked: [
		"network_wifi_1_bar_locked",
		"network_wifi_2_bar_locked",
		"network_wifi_3_bar_locked",
        "network_wifi_locked"
    ]

    contentItem: RowLayout {
        id: content
        spacing: 10

        ColumnLayout {
            Text {
                text: modelData?.name ?? null
                font.bold: modelData?.connected || modelData?.state == ConnectionState.Connecting || false
                Layout.fillWidth: true
                clip: true
            }

            Text {
                visible: modelData?.connected || modelData?.state == ConnectionState.Connecting || false
                text: {
                    switch (modelData?.state) {
                        case ConnectionState.Connecting:
                            return "Connecting..."
                        case ConnectionState.Connected:
                            return "Connected"
                    }
                    return null
                }
                fontSize: 0.9
                color: modelData?.stateChanging ? root.colFg : root.colSuccess
            }
        }

        Icon {
            text: { IconUtils.getIcon(needsAuth ? wifiIconsLocked : wifiIcons, modelData?.signalStrength ?? 0) }
        }
    }

    onClicked: {
        if (modelData.state == ConnectionState.Connected) {
            modelData.disconnect()
        } else {
            modelData.connect()
        }
    }
}

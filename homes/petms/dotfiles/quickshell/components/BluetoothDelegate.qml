import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Bluetooth
import "../components/"
import "../modules/IconUtils.js" as IconUtils

ItemDelegate {
    required property BluetoothDevice modelData

    property bool connected: modelData && modelData.state == BluetoothDeviceState.Connected && modelData.paired
    property bool stateChanging: {
        if (!modelData) return false;
        if (modelData?.pairing) return true;
        switch (modelData.state) {
            case BluetoothDeviceState.Connecting:
            case BluetoothDeviceState.Disconnecting:
                return true;
            case BluetoothDeviceState.Disconnected:
            case BluetoothDeviceState.Connected:
        }
        return false;
    }

    property string deviceStateMsg: {
        if (!modelData) return "";
        if (modelData.pairing
        || (modelData.state != BluetoothDeviceState.Disconnected && !modelData.paired)
        ) {
            return "Pairing..."
        }
        switch (modelData.state) {
            case BluetoothDeviceState.Connecting:
                return "Connecting..."
            case BluetoothDeviceState.Disconnecting:
                return "Disconnecting...";
            case BluetoothDeviceState.Disconnected:
                return "Disconnected"
            case BluetoothDeviceState.Connected:
                return "Connected"
            default:
                return "Unknown"
        }
    }

    contentItem: RowLayout {
        id: content
        spacing: 10

        ColumnLayout {
            Text {
                text: modelData?.name ?? null
                font.bold: connected || stateChanging
                Layout.fillWidth: true
                clip: true
            }

            Text {
                visible: connected || stateChanging
                text: deviceStateMsg
                fontSize: 0.9
                color: connected ? root.colSuccess : root.colFg
            }
        }

        IconButton {
            text: "settings"
            visible: !!modelData?.paired

            ContextToolTip {
                text: "Manage Device"
                visible: parent.hovered
            }

            onClicked: { if (modelData) console.error("TODO: Add bluetooth dev settings") }
        }

        Item {
            implicitHeight: 40
        }
    }

    onClicked: {
        if (!modelData) return
        if (modelData.state == BluetoothDeviceState.Connecting) return
        if (modelData.pairing) {
            return modelData.cancelPair()
        }
        if (modelData.connected) {
            return modelData.disconnect()
        }
        if (modelData.bonded) {
            modelData.connect()
        } else {
            modelData.pair()
        }
    }
}

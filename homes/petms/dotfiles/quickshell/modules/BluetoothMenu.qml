import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth
import "../components/"

ColumnLayout {
    spacing: 12
    Layout.fillWidth: true
    Layout.fillHeight: true

    property var bt: Bluetooth
    property var btAdapter: bt.defaultAdapter
    property bool hasBtHardware: !!btAdapter
    property bool btEnabled: btAdapter?.enabled || false
    property bool btReady: btAdapter?.state == BluetoothAdapterState.Enabled
    property bool discovering: btAdapter?.discovering ?? false

    onBtReadyChanged: {
        if (!btAdapter || ! btReady) return;
        btAdapter.discovering = true;
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: 8

        Title {
            Layout.fillWidth: true
            text: "Bluetooth"
        }

        // IconButton {
        //     text: discovering ? "bluetooth_disabled" : "bluetooth_searching"
        //     visible: 

        //     ContextToolTip {
        //         text: discovering ? "Stop scanning" : "Scan for Devices"
        //         visible: parent.hovered
        //     }

        //     onClicked: { if (btAdapter) btAdapter.discovering ^= true; }
        // }

        Switch {
            checkable: hasBtHardware
            checked: btEnabled
            onClicked: { if (btAdapter) btAdapter.enabled = checked }
            spacing: 0

            ContextToolTip {
                text: btEnabled ? "Turn off Bluetooth" : "Turn on Bluetooth"
                visible: parent.hovered
            }
        }
    }

    Text {
        visible: !btEnabled
        text: hasBtHardware ? "To see available devices, turn on Bluetooth." : "Bluetooth is not supported on this device."
    }

    ScrollView {
        Layout.fillWidth: true
        Layout.fillHeight: true

        ListView {
            clip: true
            spacing: 8

            visible: btEnabled

            // model: btAdapter?.devices
            model: ScriptModel {
                values: {
                    [...btAdapter?.devices.values].filter((x) => x != null).sort((a, b) => {
                        // if (a.connected !== b.connected) {
                        //     return b.connected - a.connected;
                        // }
                        if (a.paired !== b.paired) {
                            return b.paired - a.paired;
                        }
                        return a.name.localeCompare(b.name)
                    })
                }
            }

            delegate: BluetoothDelegate {
                width: parent?.width
            }
        }
    }

}

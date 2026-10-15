import QtQuick
import Quickshell
import Quickshell.Bluetooth
import "IconUtils.js" as IconUtils
import "../components/"

InlineIcon {
    id: btIcon

    property var bt: Bluetooth
    property var adapter: bt.defaultAdapter

    visible: !!adapter

    property var connected: adapter?.devices.values.some((device) => device.connected) ?? false

    text: adapter?.enabled ? (connected ? "bluetooth_connected" : "bluetooth") : "bluetooth_disabled"

    TapHandler {
        onTapped: { popup.visible = true }
    }

    HoverHandler {
        id: hoverArea
        cursorShape: Qt.PointingHandCursor
    }

    StyledToolTip {
        id: tooltip
        text: connected ? "Connected" : "Disconnected";
        visible: hoverArea.hovered
    }

    Popup {
        id: popup
        anchor {
            item: btIcon
            gravity: Edges.Top
        }

        BluetoothMenu {}
    }
}

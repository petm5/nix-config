import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.SystemTray
import "../components/"

Repeater {
    model: SystemTray.items

    delegate: Item {
        id: trayItemWrapper
        implicitWidth: root.fontSize * 1.15
        implicitHeight: root.fontSize * 1.15

        Image {
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            source: modelData.icon
        }

        Text {
            anchors.centerIn: parent
            text: modelData.title ? modelData.title.substring(0, 2) : "?"
            visible: parent.status === Image.Error || parent.status === Image.Null
        }

        QsMenuAnchor {
            id: menuAnchor
            menu: modelData.menu
            anchor.item: trayItemWrapper
            anchor.gravity: Edges.Top
        }

        TapHandler {
            onTapped: modelData.activate()
        }

        TapHandler {
            acceptedButtons: Qt.RightButton
            onTapped: if (modelData.hasMenu) menuAnchor.open()
        }

        HoverHandler {
            id: hoverArea
            cursorShape: Qt.PointingHandCursor
        }

        StyledToolTip {
            id: tooltip
            text: modelData.tooltipTitle || modelData.title || ""
            visible: hoverArea.hovered && tooltip.text.length > 0
        }
    }
}

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.SystemTray
import "../components/"

RowLayout {
    spacing: 10

    Repeater {
        model: SystemTray.items

        delegate: Item {
            id: trayItemWrapper
            implicitWidth: root.iconSize
            implicitHeight: root.iconSize

            Image {
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                source: modelData.icon
            }

            Text {
                anchors.centerIn: parent
                text: modelData.title ? modelData.title.substring(0, 2) : "?"
                visible: parent.status === Image.Error || parent.status === Image.Null
                font.pixelSize: root.fontSize
                color: "white"
            }

            QsMenuAnchor {
                id: menuAnchor
                menu: modelData.menu
                anchor.item: trayItemWrapper
                anchor.gravity: Edges.Top
            }

            MouseArea {
                id: hoverArea
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton | Qt.RightButton

                onClicked: (mouse) => {
                    if (mouse.button === Qt.LeftButton) {
                        modelData.activate(); 
                    } else if (mouse.button === Qt.RightButton) {
                        if (modelData.hasMenu) menuAnchor.open();
                    }
                }
            }

            StyledToolTip {
                id: tooltip
                text: modelData.tooltipTitle || modelData.title || ""
                visible: hoverArea.containsMouse && tooltip.text.length > 0
            }
        }
    }
}

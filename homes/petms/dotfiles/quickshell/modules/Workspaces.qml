import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.WindowManager

RowLayout {
    spacing: 8

    Repeater {
        model: [...WindowManager.windowsets].sort((a, b) => a.name.localeCompare(b.name))

        delegate: Item {
            property real size: root.fontSize * 1.2
            implicitWidth: size
            implicitHeight: size

            property bool active: modelData.active
            property bool urgent: modelData.urgent

            Rectangle {
                width: parent.width
                height: parent.height
                radius: parent.width
                scale: 0.65 + 0.1 * active
                color: active && "#9ca0b0" || urgent && "#df8e1d" || "#ccd0da"
            }

            MouseArea {
                id: hoverArea
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton

                onClicked: (mouse) => {
                    if (mouse.button === Qt.LeftButton) {
                        modelData.activate();
                    }
                }
            }
        }
    }
}

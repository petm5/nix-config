import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

ToolTip {
    id: tooltip
    delay: 200
    popupType: Popup.Window
    padding: 14

    background: Rectangle {
        color: root.colBg
        border.color: root.colBorder
        radius: 4
    }

    contentItem: Text {
        text: tooltip.text
        color: root.colFg
        font.pixelSize: root.fontSize
    }
}

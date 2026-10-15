import QtQuick
import QtQuick.Controls

ItemDelegate {
    id: control
    padding: 12

    background: Rectangle {
        color: control.hovered ? root.colFocused : root.colButton
        radius: 6
    }

    HoverHandler {
        cursorShape: Qt.PointingHandCursor
    }
}

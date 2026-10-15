import QtQuick
import QtQuick.Controls.Basic

Button {
    id: control

    contentItem: Icon {
        id: icon
        text: control.text
        opacity: enabled ? 1.0 : 0.3
        color: root.colFg
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        implicitWidth: icon.font.pixelSize
        implicitHeight: icon.font.pixelSize
        opacity: enabled ? 1 : 0.3
        radius: icon.font.pixelSize
        color: control.hovered ? root.colFocused : root.colButton
        border.color: root.colBorder
        border.width: 1
    }

    HoverHandler {
        cursorShape: Qt.PointingHandCursor
    }
}

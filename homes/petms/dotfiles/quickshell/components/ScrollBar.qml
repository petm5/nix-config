import QtQuick
import QtQuick.Controls.Basic

ScrollBar {
    id: control
    size: 0.3
    position: 0.2
    active: true

    contentItem: Rectangle {
        implicitWidth: 6
        implicitHeight: 100
        radius: width / 2
        color: control.pressed ? root.colScrollbarDown : root.colScrollbar
        opacity: control.policy === ScrollBar.AlwaysOn || (control.active && control.size < 1.0) ? 0.75 : 0

        Behavior on opacity {
            enabled: targetValue <= 0
            SequentialAnimation {
                PauseAnimation { duration: 1000 }
                NumberAnimation { duration: 250 }
            }
        }

    }
}

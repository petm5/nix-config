import QtQuick
import QtQuick.Controls.Basic

Switch {
    id: control

    indicator: Rectangle {
        id: track
        implicitWidth: 48
        implicitHeight: 26
        x: control.leftPadding
        y: parent.height / 2 - height / 2
        radius: 13
        opacity: enabled ? 1.0 : 0.3
        color: root.colButton
        border.color: root.colOutline

        Rectangle {
            id: thumb
            x: control.visualPosition * (parent.width - width)
            width: 26
            height: 26
            radius: 13
            color: control.down ? root.colFocused : "#ffffff"
            border.color: track.border.color

            Behavior on x {
                enabled: !control.down
                NumberAnimation {
                    duration: 150
                }
            }
        }
    }

    states: [
        State {
            name: "checked"
            when: control.checked
            PropertyChanges {
                target: track
                color: root.colChecked
                border.color: root.colChecked
            }
        }
    ]

    transitions: [
        Transition {
            from: "*"
            to: "*"
            ColorAnimation {
                target: track
                properties: "color, border.color"
                duration: 150
            }
        }
    ]

    HoverHandler {
        cursorShape: Qt.PointingHandCursor
    }
}

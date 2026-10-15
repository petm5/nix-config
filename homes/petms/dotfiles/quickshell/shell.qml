//@ pragma UseQApplication

import QtQuick
import Quickshell
import "./modules/"

ShellRoot{
    id: root

    property color colBg: "#eff1f5"
    property color colButton: "#e6e9ef"
    property color colOutline: "#acb0be"
    property color colFocused: "#dce0e8"
    property color colChecked: "#209fb5"
    property color colScrollbar: "#ccd0da"
    property color colScrollbarDown: "#bcc0cc"
    property color colSuccess: "#40a02b"
    property color colWarning: "#df8e1d"
    property color colError: "#d20f39"
    property color colFg: "#4c4f69"
    property color colBorder: "#ccd0da"
    property int fontSize: 14

    Variants {
        model: Quickshell.screens
        PanelWindow {
            property var modelData
            screen: modelData

            anchors {
                left: true
                right: true
                bottom: true
            }

            implicitHeight: 26

            exclusionMode: ExclusionMode.Auto

            Bar {}
        }
    }
}

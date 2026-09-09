//@ pragma UseQApplication

import QtQuick
import Quickshell
import "./modules/"

ShellRoot{
    id: root

    property color colBg: "#eff1f5"
    property color colFg: "#4c4f69"
    property color colBorder: "#ccd0da"
    property int iconSize: 16
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

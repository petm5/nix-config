import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell

PopupWindow {
    property int popupPadding: 16
    property alias spacing: contentLayout.spacing

    default property alias content: contentLayout.data

    color: "transparent"
    implicitWidth: 500
    implicitHeight: 600
    grabFocus: true

    Rectangle {
        id: content
        anchors.fill: parent
        anchors.margins: 12
        color: root.colBg
        border.color: root.colBorder
        border.width: 1
        radius: 16
        Item {
            anchors.fill: parent
            anchors.margins: popupPadding

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                ColumnLayout {
                    id: contentLayout
                    Layout.fillWidth: true
                    spacing: 12
                }

                Item {
                    Layout.fillHeight: true
                }
            }
        }
    }

    MultiEffect {
        source: content
        anchors.fill: content
        shadowBlur: 1.0
        shadowEnabled: true
        shadowColor: "black"
        paddingRect: Qt.rect(12, 12, 12, 12)
        blurMax: 16
        shadowOpacity: 0.3
    }
}

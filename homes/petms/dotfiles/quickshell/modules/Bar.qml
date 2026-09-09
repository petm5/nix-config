import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

Rectangle {
    anchors.fill: parent
    color: root.colBg

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        spacing: 12

        RowLayout {
            Layout.alignment: Qt.AlignLeft
            spacing: 12

            Workspaces {}
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 12

            Text {
                text: ToplevelManager.activeToplevel?.title ?? ""
                elide: Text.ElideMiddle
                color: root.colFg
                font.pixelSize: root.fontSize
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignRight
            spacing: 12

            SystemTray {}

            RowLayout {
                spacing: 10

                Audio {
                    color: root.colFg
                }

                Mpris {
                    color: root.colFg
                }

                Network {
                    color: root.colFg
                }

                Battery {
                    color: root.colFg
                }

                SystemClock {
                  id: clock
                  precision: SystemClock.Seconds
                }

                Text {
                    font.pixelSize: root.fontSize
                    font.bold: true
                    color: root.colFg
                    text: Qt.formatDateTime(clock.date, "hh:mm AP")
                }
            }
        }
    }
}

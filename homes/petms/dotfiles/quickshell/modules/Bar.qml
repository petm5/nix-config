import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root
    anchors.left: true
    anchors.right: true
    anchors.bottom: true
    implicitHeight: 26
    
    exclusionMode: ExclusionMode.Auto

    property color colBg: "#1e1e2e"
    property color colFg: "#cdd6f4"
    property color colBorder: "#313244"
    property int iconSize: 16
    property int fontSize: 14

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
                        color: "#a6e3a1"
                    }

                    Mpris {
                        color: "#f5c2e7"
                    }
                        
                    Network {
                        color: "#89b4fa"
                    }

                    Battery {
                        color: "#f9e2af"
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
}

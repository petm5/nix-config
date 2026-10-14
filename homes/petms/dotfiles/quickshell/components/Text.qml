import QtQuick

Text {
    id: text
    property real fontSize: 1

    font.pixelSize: root.fontSize * fontSize
    color: root.colFg
}

import QtQuick

Text {
    property real fontSize: 1

    font.pixelSize: root.fontSize * fontSize * 1.15
    font.family: "Material Symbols Outlined"
}

import QtQuick
import Qt.labs.animation

ListView {
    id: list

    WheelHandler {
        acceptedDevices: PointerDevice.TouchPad
        onWheel: function(event) {
            var step = event.angleDelta.y * 0.5
            var minY = list.originY
            var maxY = list.originY + list.contentHeight - list.height
            if (maxY <= minY) return
            list.contentY = Math.max(minY, Math.min(list.contentY - step, maxY))
        }
    }
}

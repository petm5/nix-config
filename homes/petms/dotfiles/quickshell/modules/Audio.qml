import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import "IconUtils.js" as IconUtils
import "../components/"

Text {
    font.family: "Material Symbols Outlined"
    font.pixelSize: root.iconSize

    property var audioIcons: [
        "volume_mute",
        "volume_down",
        "volume_up"
    ]

    property PwNode node: Pipewire.defaultAudioSink

    PwObjectTracker { objects: [ node ] }

    property var activeAudio: node?.audio;

    visible: Pipewire.ready && !!activeAudio

    text: {
        if (!visible || !activeAudio) {
            return "";
        }

        if (activeAudio.muted) {
            return "volume_off";
        }

        return IconUtils.getIcon(audioIcons, activeAudio.volume);
    }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true
    }

    StyledToolTip {
        id: tooltip
        text: {
            if (!activeAudio) {
                return "";
            }

            return node.nickname || node.description || node.name;
        }
        visible: hoverArea.containsMouse && tooltip.text.length > 0
    }
}

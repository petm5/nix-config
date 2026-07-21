import QtQuick
import Quickshell
import Quickshell.Services.Mpris

Text {
	id: mpris

	function getPlayerStatus() {
		let player = null;

        for (let i = 0; i < Mpris.players.values.length; i++) {
            player = Mpris.players.values[i];
            break;
        }

        if (!player || player.playbackState == MprisPlaybackState.Stopped) {
        	mpris.visible = false;
	    	return "music_off";
	    }

    	mpris.visible = true;

		if (player.isPlaying) {
			return "play_arrow";
		}

		return "pause";
	}

    font.family: "Material Symbols Outlined"
    font.pixelSize: root.iconSize

    text: getPlayerStatus()
}

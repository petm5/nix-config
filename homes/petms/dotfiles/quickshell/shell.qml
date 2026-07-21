//@ pragma UseQApplication

import QtQuick
import Quickshell
import "./modules/"

ShellRoot{
    id: root

    // Niri {
    //     id: niri
    //     Component.onCompleted: connect()

    //     onConnected: console.info("Connected to niri")
    //     onErrorOccurred: function(error) {
    //         console.error("Niri error:", error)
    //     }
    // }

    LazyLoader { active: true; component: Bar {} }
}

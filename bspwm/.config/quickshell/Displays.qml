pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property string primaryName: ""
    property bool queried: false

    // xrandr's primary output is not always one of quickshell's screens: a dock
    // output can stay marked primary while disabled, so fall back to the first
    // screen rather than leaving the desktop without a bar. Nothing is returned
    // until xrandr answers, otherwise the bar would flash on the wrong monitor.
    readonly property var primaryScreens: {
        if (!root.queried)
            return [];

        const screens = Quickshell.screens;
        if (screens.length === 0)
            return [];

        for (let i = 0; i < screens.length; i++) {
            if (screens[i].name === root.primaryName)
                return [screens[i]];
        }

        return [screens[0]];
    }

    Process {
        id: queryProc

        running: true
        command: ["xrandr", "--query"]

        stdout: StdioCollector {
            onStreamFinished: {
                const match = /^(\S+) connected primary/m.exec(this.text);
                root.primaryName = match ? match[1] : "";
                root.queried = true;
            }
        }
    }

    Connections {
        target: Quickshell

        function onScreensChanged() {
            queryProc.running = true;
        }
    }
}

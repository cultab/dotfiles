pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property string title: ""

    Process {
        id: titleProc

        running: true
        command: ["sh", `${Quickshell.shellDir}/scripts/title.sh`]
        onExited: restartTimer.start()

        stdout: SplitParser {
            onRead: line => root.title = line
        }
    }

    Timer {
        id: restartTimer

        interval: 2000
        onTriggered: titleProc.running = true
    }
}

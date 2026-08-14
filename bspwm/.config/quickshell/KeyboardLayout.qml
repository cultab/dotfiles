pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property string layout: ""

    Process {
        id: queryProc

        running: true
        command: ["setxkbmap", "-query"]

        stdout: StdioCollector {
            onStreamFinished: {
                const match = /^layout:\s*(.+)$/m.exec(this.text);
                if (match)
                    root.layout = match[1].trim();
            }
        }
    }

    Timer {
        interval: 2000
        repeat: true
        running: true
        onTriggered: queryProc.running = true
    }
}

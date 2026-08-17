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
        command: ["xkblayout-state", "print", "%s"]

        stdout: StdioCollector {
            onStreamFinished: {
                root.layout = this.text
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

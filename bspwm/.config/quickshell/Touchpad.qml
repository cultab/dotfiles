pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool available: false
    property bool enabled: false

    function toggle() {
        toggleProc.running = true;
    }

    function readState(output: string) {
        const state = output.trim();
        root.available = state === "0" || state === "1";
        root.enabled = state === "1";
    }

    Process {
        running: true
        command: ["sh", `${Quickshell.shellDir}/scripts/touchpad.sh`]

        stdout: StdioCollector {
            onStreamFinished: root.readState(this.text)
        }
    }

    Process {
        id: toggleProc

        command: ["sh", `${Quickshell.shellDir}/scripts/touchpad.sh`, "toggle"]

        stdout: StdioCollector {
            onStreamFinished: root.readState(this.text)
        }
    }
}

import Quickshell
import Quickshell.Io
import QtQuick

BarModule {
    id: root

    onClicked: toggleProc.running = true

    Process {
        id: toggleProc

        command: ["xkblayout-state", "set", "+1"]
    }

    visible: KeyboardLayout.layout !== ""
    accent: Theme.dark

    BarIcon {
        color: root.contentColor
        text: Icons.keyboard
    }

    BarLabel {
        color: root.contentColor
        text: KeyboardLayout.layout
    }
}

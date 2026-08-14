//@ pragma UseQApplication

import Quickshell
import QtQuick

ShellRoot {
    Bar {}

    // Tray items provide their own menus as platform menus, which need the
    // QApplication pragma above.
    TrayPanel {}

    // The popup is worth keeping when a reload fails, since it carries the error,
    // but on a successful reload it just sits there until clicked.
    Connections {
        target: Quickshell

        function onReloadCompleted() {
            Quickshell.inhibitReloadPopup();
        }
    }
}

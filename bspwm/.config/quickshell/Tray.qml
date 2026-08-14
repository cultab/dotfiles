pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root

    // The tray lives in its own panel that stays hidden until asked for, the
    // way polybar's traybar did. toggle-traybar drives this over ipc.
    property bool shown: false

    function toggle() {
        root.shown = !root.shown;
    }

    IpcHandler {
        target: "tray"

        function toggle(): void {
            root.toggle();
        }

        // Not named show/hide: `qs ipc` has its own `show` subcommand, which
        // swallows `qs ipc call tray show` before it reaches us.
        function open(): void {
            root.shown = true;
        }

        function close(): void {
            root.shown = false;
        }

        function isShown(): bool {
            return root.shown;
        }
    }
}

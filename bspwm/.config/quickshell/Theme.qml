pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    // polybar used `Iosevka:size=10` and `Symbols Nerd Font Mono:pixelsize=16`
    readonly property string fontFamily: "Iosevka"
    readonly property real fontSize: 10
    readonly property string iconFamily: "Symbols Nerd Font"
    readonly property int iconSize: 16

    property color background: "#ffffff"
    property color foreground: "#202020"
    property color active: "#80a0ff"
    property color red: "#c03545"
    property color green: "#1cad3c"
    property color yellow: "#eab700"
    property color blue: "#0d33a5"
    property color purple: "#6f42c1"
    property color cyan: "#2076d8"
    property color dark: "#202020"

    // Re-reads the palette from the X resource database. reload_xrdb calls this
    // over ipc after loading a new theme, so `themr` restyles the bar in place.
    function reload() {
        xresourcesProc.running = true;
    }

    Process {
        id: xresourcesProc

        running: true
        command: ["xrdb", "-query"]

        stdout: StdioCollector {
            onStreamFinished: root.applyXresources(this.text)
        }
    }

    IpcHandler {
        target: "theme"

        function reload(): void {
            root.reload();
        }
    }

    function applyXresources(query: string) {
        const resources = {};

        for (const line of query.split("\n")) {
            const separator = line.indexOf(":");
            if (separator === -1)
                continue;

            const name = line.slice(0, separator).replace(/^\*\.?/, "");
            resources[name] = line.slice(separator + 1).trim();
        }

        function pick(name, fallback) {
            const value = resources[name];
            return value && value.startsWith("#") ? value : fallback;
        }

        root.background = pick("polybar.background", pick("background", root.background));
        root.foreground = pick("polybar.foreground", pick("foreground", root.foreground));
        root.active = pick("selection", root.active);
        root.red = pick("color1", root.red);
        root.green = pick("color2", root.green);
        root.yellow = pick("color3", root.yellow);
        root.blue = pick("color4", root.blue);
        root.purple = pick("color5", root.purple);
        root.cyan = pick("color6", root.cyan);
        root.dark = pick("color7", root.dark);
    }
}

pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    // monitor name -> [{ name, focused, occupied, urgent }]
    property var desktops: ({})
    property string focusedMonitor: ""
    // assume default layout is monocle
    property string layout: "monocle"

    readonly property var desktopLabels: ({
            "I": { text: "web", icon: Icons.globe },
            "II": { text: "local", icon: Icons.terminal },
            "III": { text: "ssh", icon: Icons.terminal },
            "IV": { text: "email", icon: Icons.mail },
            "V": { text: "teams", icon: Icons.teams },
            "VI": { text: "cfg", icon: Icons.gear }
    })

    function labelFor(desktop: string): var {
        return root.desktopLabels[desktop] ?? { text: desktop, icon: Icons.terminal };
    }

    // bspc only accepts a monitor prefix with positional selectors, not with
    // desktop names, hence the 1 based index rather than the desktop's name.
    function focusDesktop(monitor: string, index: int) {
        focusProc.command = ["bspc", "desktop", `${monitor}:^${index + 1}`, "--focus"];
        focusProc.running = true;
    }

    // report lines look like: WMeDP-1:oI:OII:fIII:oIV:oV:oVI:LM:TT:G
    function readReport(report: string) {
        if (report.startsWith("W")) {
            const byMonitor = {};
            let monitor = null;
            let focused = "";

            for (const field of report.slice(1).split(":")) {
                const kind = field.slice(0, 1);
                const value = field.slice(1);

                if (kind === "M" || kind === "m") {
                    monitor = value;
                    byMonitor[monitor] = [];
                    if (kind === "M")
                    focused = monitor;
                } else if (monitor !== null && "OoFfUu".includes(kind)) {
                    byMonitor[monitor].push({
                            name: value,
                            focused: kind === kind.toUpperCase(),
                            occupied: kind === "O" || kind === "o",
                            urgent: kind === "U" || kind === "u"
                    });
                }
            }

            root.desktops = byMonitor;
            root.focusedMonitor = focused;
        } else if (report.startsWith("desktop_layout")) {
            let line = report.split(" ")
            let layout = line[3]
            console.log(line)
            console.log(layout)
            root.layout = layout
        }
    }

	Process {
		id: layoutToggle

		command: ["bspc", "desktop", "-l", "next"]
	}

    Process {
        id: reportProc

        running: true
        command: ["bspc", "subscribe", "report", "desktop_layout"]
        onExited: restartTimer.start()

        stdout: SplitParser {
            onRead: line => root.readReport(line)
        }
    }

    Process { id: focusProc }

    Timer {
        id: restartTimer

        interval: 200
        onTriggered: reportProc.running = true
    }
}

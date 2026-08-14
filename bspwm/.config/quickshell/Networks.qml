pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Networking
import QtQuick

Singleton {
    id: root

    // [{ name, address, wireless }], wireless first, matching polybar's wlan/eth order
    property var connections: []

    // NetworkManager tells us when a link goes up or down, but it only exposes
    // hardware addresses, so the local IP still has to come from `ip`.
    readonly property int linkCount: {
        let count = 0;
        for (const device of Networking.devices.values) {
            if (device.connected)
                count++;
        }
        return count;
    }

    onLinkCountChanged: settleTimer.restart()

    function readAddresses(output: string) {
        const wireless = [];
        const wired = [];

        for (const line of output.split("\n")) {
            const fields = line.trim().split(/\s+/);
            if (fields.length < 4 || fields[2] !== "inet")
                continue;

            const name = fields[1];
            const address = fields[3].split("/")[0];

            if (name.startsWith("wl"))
                wireless.push({ name: name, address: address, wireless: true });
            else if (name.startsWith("en") || name.startsWith("eth"))
                wired.push({ name: name, address: address, wireless: false });
        }

        root.connections = wireless.concat(wired);
    }

    Process {
        id: addressProc

        running: true
        command: ["ip", "-4", "-oneline", "address", "show"]

        stdout: StdioCollector {
            onStreamFinished: root.readAddresses(this.text)
        }
    }

    // a link coming up precedes its address by a moment
    Timer {
        id: settleTimer

        interval: 1000
        onTriggered: addressProc.running = true
    }

    // catches address changes that do not flap the link, such as DHCP renewals
    Timer {
        interval: 60000
        repeat: true
        running: true
        onTriggered: addressProc.running = true
    }
}

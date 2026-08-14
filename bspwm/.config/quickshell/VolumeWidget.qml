import QtQuick
import Quickshell.Services.Pipewire

BarModule {
    id: root

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property real volume: root.sink?.audio?.volume ?? 0
    readonly property bool muted: root.sink?.audio?.muted ?? false

    accent: Theme.red

    onClicked: {
        if (root.sink?.audio)
            root.sink.audio.muted = !root.sink.audio.muted;
    }

    onWheelMoved: wheel => {
        if (!root.sink?.audio)
            return;

        const step = wheel.angleDelta.y > 0 ? 0.05 : -0.05;
        root.sink.audio.volume = Math.max(0, Math.min(1, root.sink.audio.volume + step));
    }

    PwObjectTracker {
        objects: [root.sink]
    }

    BarIcon {
        color: root.contentColor
        text: root.muted
            ? Icons.volumeMuted
            : root.volume > 0.5 ? Icons.volumeHigh : Icons.volumeLow
    }

    BarLabel {
        color: root.contentColor
        text: `${String(Math.round(root.volume * 100)).padStart(3, " ")}%`
    }
}

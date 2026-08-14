pragma Singleton

import Quickshell
import QtQuick

// Shape and layout, kept apart from Theme's palette so the whole look can be
// swapped by one line, the way polybar picks between its *_modules.ini files.
Singleton {
    id: root

    readonly property string variant: "square" // themr:quickshell #

    readonly property bool round: root.variant === "round"

    readonly property int barHeight: root.round ? 28 : 24
    readonly property int barPadding: root.round ? 8 : 4
    readonly property int modulePadding: root.round ? 10 : 8
    readonly property int moduleSpacing: root.round ? 6 : 3
    readonly property int moduleRadius: root.round ? Math.round(root.barHeight / 2) : 0
    readonly property int desktopSpacing: root.round ? root.moduleSpacing : 0
    readonly property int underlineSize: root.round ? 2 : 0
    readonly property int contentSpacing: 5

    readonly property color barBackground: root.round ? "transparent" : Theme.background

    // Round modules let the desktop through their pill rather than sitting on a
    // bar; square ones have the bar itself behind them.
    readonly property real moduleOpacity: 0.75
    readonly property color moduleBackground: root.round
        ? Qt.rgba(Theme.background.r, Theme.background.g, Theme.background.b, root.moduleOpacity)
        : "transparent"

    // Square modules carry their accent as a background with the content knocked
    // out of it; round ones share a translucent pill and tint the content instead.
    readonly property bool filled: !root.round
}

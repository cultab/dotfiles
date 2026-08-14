pragma Singleton

import Quickshell

// Nerd Font glyphs, kept as codepoints so the files stay ascii and survive font edits.
Singleton {
    readonly property string globe: String.fromCodePoint(0xf0ac)
    readonly property string terminal: String.fromCodePoint(0xe795)
    readonly property string mail: String.fromCodePoint(0xf01ee)
    readonly property string teams: String.fromCodePoint(0xf0528)
    readonly property string gear: String.fromCodePoint(0xf013)

    readonly property string keyboard: String.fromCodePoint(0xf030c)
    readonly property string toggleOn: String.fromCodePoint(0xf205)
    readonly property string toggleOff: String.fromCodePoint(0xf204)
    readonly property string caretDown: String.fromCodePoint(0xf0d7)
    readonly property string caretUp: String.fromCodePoint(0xf0d8)
    readonly property string wifi: String.fromCodePoint(0xf05a9)
    readonly property string ethernet: String.fromCodePoint(0xf0200)

    readonly property string volumeLow: String.fromCodePoint(0xf027)
    readonly property string volumeHigh: String.fromCodePoint(0xf028)
    readonly property string volumeMuted: String.fromCodePoint(0xf0581)

    readonly property var batteryRamp: [0xf244, 0xf243, 0xf242, 0xf241, 0xf240].map(code => String.fromCodePoint(code))
    readonly property var chargingRamp: [0xf243, 0xf242, 0xf241, 0xf240].map(code => String.fromCodePoint(code))
}




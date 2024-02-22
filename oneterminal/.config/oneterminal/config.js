// see https://github.com/atinylittleshell/TerminalOne/blob/main/packages/types/defaultConfig.ts for supported configuration values
module.exports = {
    /*
    * This is the default configuration values for Terminal One.
    */
    // Whether to use acrylic effect on the window background. This is only supported on Mac and Win 11.
    acrylic: false,

    // Number of lines to keep in the scrollback buffer.
    scrollback: 10000,

    // Whether to copy text to the clipboard on selection.
    copyOnSelect: true,

    // Whether to blink the cursor.
    cursorBlink: true,

    // Style of the cursor. Valid values are 'block', 'underline', and 'bar'.
    cursorStyle: 'block',

    // Width of the cursor in pixels.
    cursorWidth: 1,

    // Font size in pixels.
    fontSize: 16,

    // Font family. Follows css syntax.
    fontFamily: 'Monaspace Argon, CaskaydiaCove Nerd Font Mono, monospace',

    // Font weight for normal text. Valid values are 100-900 in multiples of 100.
    fontWeight: 400,

    // Font weight for bold text. Valid values are 100-900 in multiples of 100.
    fontWeightBold: 500,

    // Letter spacing in pixels.
    letterSpacing: 1,

    // Line height relative to font size.
    lineHeight: 1,

    // Padding within each terminal in pixels.
    terminalContentPadding: {
        top: 2,
        right: 2,
        bottom: 2,
        left: 2,
    },

    // Border width of each terminal in pixels.
    terminalBorderWidth: 1,

    // Border color of each terminal when it is active.
    terminalBorderColorActive: 'foreground',

    // Border color of each terminal when it is inactive.
    terminalBorderColorInactive: 'background',

    // Configuration for the color scheme. Default is https://rosepinetheme.com/.
    colorScheme: {
        cursor: '#56526e',
        cursorAccent: '#e0def4',

        selectionBackground: '#312f44',
        selectionForeground: '#e0def4',
        selectionInactiveBackground: '#312f44',

        background: "#24283b",
        foreground "#c0caf5",

        black: "#1d202f",
        red: "#f7768e",
        green: "#9ece6a",
        yellow: "#e0af68",
        blue: "#7aa2f7",
        purple: "#bb9af7",
        cyan: "#7dcfff",
        white: "#a9b1d6",
        brightBlack: "#414868",
        brightRed: "#f7768e",
        brightGreen: "#9ece6a",
        brightYellow: "#e0af68",
        brightBlue: "#7aa2f7",
        brightPurple: "#bb9af7",
        brightCyan: "#7dcfff",
        brightWhite: "#c0caf5",
    },
    // colorScheme: {
    //     cursor: '#56526e',
    //     cursorAccent: '#e0def4',

    //     selectionBackground: '#312f44',
    //     selectionForeground: '#e0def4',
    //     selectionInactiveBackground: '#312f44',

    //     background: '#232136',
    //     foreground: '#e0def4',

    //     black: '#393552',
    //     blue: '#9ccfd8',
    //     cyan: '#ea9a97',
    //     green: '#3e8fb0',
    //     magenta: '#c4a7e7',
    //     red: '#eb6f92',
    //     white: '#e0def4',
    //     yellow: '#f6c177',

    //     brightBlack: '#817c9c',
    //     brightBlue: '#9ccfd8',
    //     brightCyan: '#ea9a97',
    //     brightGreen: '#3e8fb0',
    //     brightMagenta: '#c4a7e7',
    //     brightRed: '#eb6f92',
    //     brightWhite: '#e0def4',
    //     brightYellow: '#f6c177',
    // },

    // Configuration for all shells to be used in the terminal.
    shells: [
        // {
        //     // Name of the shell.
        //     name: 'Default',

        //     // Command used to launch the shell. Will auto detect system shell when this is empty.
        //     command: '',

        //     // Path to the directory where the shell should be launched. Will auto detect home directory when this is empty.
        //     startupDirectory: '',
        // },
        {
            // Name of the shell.
            name: 'WSL',

            // Command used to launch the shell. Will auto detect system shell when this is empty.
            command: 'wsl.exe --cd ~',

            // Path to the directory where the shell should be launched. Will auto detect home directory when this is empty.
            startupDirectory: '',
        },
    ],

    // Name of the default shell to use. This must match one of the names defined in "shells".
    defaultShellName: 'WSL',

    // The keybind to use as the leader key. This keybind will be used to trigger all other keybinds.
    // Pressing this keybind twice will "escape" the leader and send the key into the terminal.
    keybindLeader: 'ctrl+s',

    // Keybinds to use for the terminal.
    // These keybinds will be active only within 1 second after the leader key is pressed.
    keybinds: {
        createTab: 'c',
        closeTab: 'd',
        nextTab: 'n',
        previousTab: 'p',
        tab1: '1',
        tab2: '2',
        tab3: '3',
        tab4: '4',
        tab5: '5',
        tab6: '6',
        tab7: '7',
        tab8: '8',
        tab9: '9',
        splitHorizontal: '-',
        splitVertical: '\\',
        focusPaneLeft: 'h',
        focusPaneRight: 'l',
        focusPaneUp: 'k',
        focusPaneDown: 'j',
        closePane: 'x',
    },

};

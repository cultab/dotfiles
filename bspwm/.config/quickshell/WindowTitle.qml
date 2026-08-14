import QtQuick

BarModule {
    id: root

    readonly property int maxLength: 120

    visible: ActiveWindow.title !== ""
    accent: Theme.yellow

    BarLabel {
        color: root.contentColor
        text: ActiveWindow.title.length > root.maxLength
            ? `${ActiveWindow.title.slice(0, root.maxLength - 1)}\u2026`
            : ActiveWindow.title
    }
}

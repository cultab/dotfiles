import QtQuick

BarModule {
    id: root

    emphasized: false

    onClicked: Tray.toggle()

    BarIcon {
        color: root.contentColor
        text: Tray.shown ? Icons.caretUp : Icons.caretDown
    }
}

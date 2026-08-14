import QtQuick

BarModule {
    id: root

    visible: Touchpad.available
    accent: Theme.yellow

    onClicked: Touchpad.toggle()

    BarIcon {
        color: root.contentColor
        text: Touchpad.enabled ? Icons.toggleOn : Icons.toggleOff
    }
}

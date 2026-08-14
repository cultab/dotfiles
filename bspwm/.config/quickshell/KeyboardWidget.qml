import QtQuick

BarModule {
    id: root

    visible: KeyboardLayout.layout !== ""
    accent: Theme.dark

    BarIcon {
        color: root.contentColor
        text: Icons.keyboard
    }

    BarLabel {
        color: root.contentColor
        text: KeyboardLayout.layout
    }
}

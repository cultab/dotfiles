import QtQuick

Row {
    id: root

    required property string monitor

    readonly property var desktops: Bspwm.desktops[root.monitor] ?? []

    spacing: Style.desktopSpacing

    Repeater {
        model: root.desktops

        BarModule {
            id: desktop

            required property var modelData
            required property int index

            readonly property var label: Bspwm.labelFor(desktop.modelData.name)

            accent: desktop.modelData.urgent ? Theme.red : Theme.active
            emphasized: desktop.modelData.focused || desktop.modelData.urgent

            onClicked: Bspwm.focusDesktop(root.monitor, desktop.index)

            BarLabel {
                color: desktop.contentColor
                text: desktop.label.text
                visible: this.text !== ""
            }

            BarIcon {
                color: desktop.contentColor
                text: desktop.label.icon
            }
        }
    }
}

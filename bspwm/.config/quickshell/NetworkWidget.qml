import QtQuick

Row {
    spacing: Style.moduleSpacing

    Repeater {
        model: Networks.connections

        BarModule {
            id: connection

            required property var modelData

            accent: Theme.purple

            BarIcon {
                color: connection.contentColor
                text: connection.modelData.wireless ? Icons.wifi : Icons.ethernet
            }

            BarLabel {
                color: connection.contentColor
                text: connection.modelData.address
            }
        }
    }
}

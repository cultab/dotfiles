import Quickshell.Io
import Quickshell
import QtQuick

Scope {
    Variants {
        model: Displays.primaryScreens

        PanelWindow {
            id: bar

            required property var modelData

            screen: bar.modelData
            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: Style.barHeight + Style.barPadding * 2
            color: Style.barBackground

            // The style can turn the background transparent after the window was
            // created opaque, which otherwise leaves it stuck painting black.
            surfaceFormat.opaque: false

            Item {
                anchors.fill: parent
                anchors.margins: Style.barPadding

                Row {
                    anchors.left: parent.left
                    anchors.right: clockWidget.left
                    anchors.rightMargin: Style.moduleSpacing
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: Style.moduleSpacing

                    LayoutWidget {}

                    Workspaces {
                        monitor: bar.modelData.name
                    }

                    WindowTitle {}
                }

                ClockWidget {
                    id: clockWidget
                    anchors.centerIn: parent
                }

                Row {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: Style.moduleSpacing

                    VolumeWidget {}

                    TouchpadWidget {}

                    KeyboardWidget {}

                    NetworkWidget {}

                    BatteryWidget {}

                    TrayToggle {}
                }
            }

            // hack to bar sits just over bspwm's root window
            Process {
                id: lowerProc
                running: true
                command: ["sh", "-c", `xdo lower -p ${Quickshell.processId};
                                       xdo lower -N Bspwm`]
            }

            Timer {
                id: lowerTimer

                interval: 1000 * 30 // every 30 seconds
                onTriggered: lowerProc.running = true
            }
        }
    }
}

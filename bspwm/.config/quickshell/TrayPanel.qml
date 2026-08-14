import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick

Scope {
    Variants {
        model: Displays.primaryScreens

        PanelWindow {
            id: panel

            required property var modelData

            screen: panel.modelData
            visible: Tray.shown

            // Size and placement carried over from polybar's traybar.ini, which
            // put the tray below the bar, toward the right of the screen.
            implicitWidth: 200
            implicitHeight: 30

            anchors {
                top: true
                right: true
            }

            // Read from modelData rather than screen: the latter is derived from
            // the window's position, which these margins decide, so it loops.
            margins {
                right: Math.round(10)
                top: Math.round(implicitHeight * 1.2)
            }

            // It floats over windows instead of reserving space, so bspwm needs
            // to keep laying out windows as if it were not there.
            exclusionMode: ExclusionMode.Ignore
            color: "transparent"
            surfaceFormat.opaque: false

            Rectangle {
                anchors.fill: parent
                radius: Style.moduleRadius
                color: Theme.background
                border.color: Theme.blue
                border.width: 2
            }

            Row {
                anchors.centerIn: parent
                spacing: Style.modulePadding

                Repeater {
                    model: SystemTray.items

                    MouseArea {
                        id: item

                        required property SystemTrayItem modelData

                        implicitWidth: icon.implicitWidth
                        implicitHeight: icon.implicitHeight
                        acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton

                        onClicked: mouse => {
                            if (mouse.button === Qt.MiddleButton) {
                                item.modelData.secondaryActivate();
                            } else if (mouse.button === Qt.RightButton || item.modelData.onlyMenu) {
                                const corner = item.mapToItem(null, 0, item.height);
                                item.modelData.display(panel, corner.x, corner.y);
                            } else {
                                item.modelData.activate();
                            }
                        }

                        onWheel: wheel => item.modelData.scroll(wheel.angleDelta.y, false)

                        IconImage {
                            id: icon

                            // polybar limited icons to 16px with tray-maxsize
                            implicitSize: 16
                            source: item.modelData.icon
                        }
                    }
                }
            }
        }
    }
}

import QtQuick

// Chrome shared by every bar module. Children go into a centred row and take
// their color from contentColor, which follows whichever style is selected.
Rectangle {
    id: root

    default property alias content: layout.data
    property color accent: Theme.foreground
    // Whether the module paints itself with its accent, as opposed to sitting
    // there neutrally like the clock or an unfocused desktop.
    property bool emphasized: true

    readonly property bool solid: Style.filled && root.emphasized
    readonly property color contentColor: root.solid
        ? Theme.background
        : root.emphasized ? root.accent : Theme.foreground

    // The hitbox lives here because a MouseArea passed as content would end up
    // inside the row, where it cannot be anchored.
    property alias acceptedButtons: hitbox.acceptedButtons

    signal clicked(var mouse)
    signal wheelMoved(var wheel)

    implicitWidth: root.visible ? layout.implicitWidth + Style.modulePadding * 2 : 0
    implicitHeight: Style.barHeight
    radius: Style.moduleRadius
    color: root.solid ? root.accent : Style.moduleBackground

    Row {
        id: layout

        anchors.centerIn: parent
        spacing: Style.contentSpacing
    }

    // Round modules all share one pill color, so emphasis needs the underline
    // polybar drew with label-focused-underline. It stops short of the capsule's
    // curve, which its square ends would otherwise stick out of.
    Rectangle {
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            leftMargin: root.radius
            rightMargin: root.radius
        }

        height: Style.underlineSize
        radius: this.height / 2
        visible: Style.round && root.emphasized
        color: root.accent
    }

    MouseArea {
        id: hitbox

        anchors.fill: parent
        onClicked: mouse => root.clicked(mouse)
        onWheel: wheel => root.wheelMoved(wheel)
    }
}

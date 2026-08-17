import QtQuick

BarModule {
    id: root

    visible: ActiveWindow.title !== ""
    accent: Theme.yellow

    BarLabel {
        color: root.contentColor
        text: ActiveWindow.title
        elide: Text.ElideRight
        maximumLineCount: 1
        width: Math.min(implicitWidth, root.parent.width - root.parent.children[0].implicitWidth - Style.moduleSpacing - Style.modulePadding * 2)
    }
}

import Quickshell
import Quickshell.Io
import QtQuick

BarModule {
	id: root

	visible: true
	accent: Theme.blue
	width: Style.modulePadding * 2 + Theme.iconSize

	BarLabel {
		color: root.contentColor
		text: {
			switch(Bspwm.layout) {
				case "monocle": {
					Icons.fullscreen
					break
				}
				case "tiled": {
					Icons.tiling
					break
				}
				default: {
					"unkwn"
					break
				}
			}
			// elide: Text.ElideRight
			// maximumLineCount: 1
		}
	}
}

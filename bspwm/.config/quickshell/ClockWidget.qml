import Quickshell

BarModule {
    id: root

    emphasized: false

    SystemClock {
        id: clock

        precision: SystemClock.Minutes
    }

    BarLabel {
        color: root.contentColor
        text: Qt.formatDateTime(clock.date, "dd/MM/yyyy HH:mm")
    }
}

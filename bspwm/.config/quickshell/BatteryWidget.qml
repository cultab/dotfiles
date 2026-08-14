import QtQuick
import Quickshell.Services.UPower

BarModule {
    id: root

    readonly property UPowerDevice battery: UPower.displayDevice
    readonly property int percentage: Math.round((root.battery?.percentage ?? 0) * 100)
    readonly property bool charging: root.battery?.state === UPowerDeviceState.Charging

    visible: root.battery?.isLaptopBattery ?? false
    accent: Theme.green

    Timer {
        id: chargeAnimation

        property int frame: 0

        interval: 500
        repeat: true
        running: root.charging
        onTriggered: this.frame = (this.frame + 1) % Icons.chargingRamp.length
    }

    BarIcon {
        color: root.contentColor
        text: root.charging
            ? Icons.chargingRamp[chargeAnimation.frame]
            : Icons.batteryRamp[Math.min(4, Math.floor(root.percentage / 20))]
    }

    BarLabel {
        color: root.contentColor
        text: `${root.percentage}%`
    }
}

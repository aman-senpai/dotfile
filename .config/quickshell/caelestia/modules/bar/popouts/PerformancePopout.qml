pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import Caelestia.Services
import qs.components
import qs.components.controls
import qs.services

StyledRect {
    id: root

    implicitWidth: 300
    implicitHeight: layout.implicitHeight + Tokens.padding.medium * 2

    radius: Tokens.rounding.large
    color: Colours.tPalette.m3surfaceContainer

    ServiceRef {
        service: Cpu
    }

    ServiceRef {
        service: Memory
    }

    ServiceRef {
        service: Storage
    }

    ColumnLayout {
        id: layout

        anchors.fill: parent
        anchors.margins: Tokens.padding.medium
        spacing: Tokens.spacing.small

        RowLayout {
            Layout.fillWidth: true

            StyledText {
                text: qsTr("System Performance")
                font: Tokens.font.body.builders.medium.weight(Font.DemiBold).build()
                color: Colours.palette.m3primary
            }

            Item { Layout.fillWidth: true }

            MaterialIcon {
                text: "speed"
                fontStyle: Tokens.font.icon.small
                color: Colours.palette.m3secondary
            }
        }

        // CPU Metric Row
        RowLayout {
            Layout.fillWidth: true
            spacing: Tokens.spacing.small

            MaterialIcon {
                text: "memory"
                fontStyle: Tokens.font.icon.small
                color: Colours.palette.m3primary
            }

            StyledText {
                text: qsTr("CPU: %1%").arg(Math.round((Cpu.percentage ?? 0) * 100))
                font: Tokens.font.body.small
                color: Colours.palette.m3onSurface
                Layout.preferredWidth: 70
            }

            StyledProgressBar {
                Layout.fillWidth: true
                value: Cpu.percentage ?? 0
                implicitHeight: Tokens.padding.extraSmall
                fgColour: Colours.palette.m3primary
            }

            StyledText {
                text: `${Math.ceil(Cpu.temperature ?? 0)}°C`
                font: Tokens.font.body.builders.small.weight(Font.Medium).build()
                color: (Cpu.temperature ?? 0) > 85 ? Colours.palette.m3error : Colours.palette.m3onSurfaceVariant
            }
        }

        // RAM Metric Row
        RowLayout {
            Layout.fillWidth: true
            spacing: Tokens.spacing.small

            MaterialIcon {
                text: "memory_alt"
                fontStyle: Tokens.font.icon.small
                color: Colours.palette.m3tertiary
            }

            StyledText {
                text: qsTr("RAM: %1%").arg(Math.round((Memory.percentage ?? 0) * 100))
                font: Tokens.font.body.small
                color: Colours.palette.m3onSurface
                Layout.preferredWidth: 70
            }

            StyledProgressBar {
                Layout.fillWidth: true
                value: Memory.percentage ?? 0
                implicitHeight: Tokens.padding.extraSmall
                fgColour: Colours.palette.m3tertiary
            }

            StyledText {
                text: Memory.used ? `${Math.round(Memory.used / 1024 / 1024 / 1024 * 10) / 10}G` : ""
                font: Tokens.font.body.builders.small.scale(0.9).build()
                color: Colours.palette.m3onSurfaceVariant
            }
        }

        // Disk Metric Row
        RowLayout {
            Layout.fillWidth: true
            spacing: Tokens.spacing.small

            MaterialIcon {
                text: "hard_disk"
                fontStyle: Tokens.font.icon.small
                color: Colours.palette.m3secondary
            }

            StyledText {
                text: qsTr("Disk: %1%").arg(Math.round((Storage.percentage ?? 0) * 100))
                font: Tokens.font.body.small
                color: Colours.palette.m3onSurface
                Layout.preferredWidth: 70
            }

            StyledProgressBar {
                Layout.fillWidth: true
                value: Storage.percentage ?? 0
                implicitHeight: Tokens.padding.extraSmall
                fgColour: Colours.palette.m3secondary
            }
        }
    }
}

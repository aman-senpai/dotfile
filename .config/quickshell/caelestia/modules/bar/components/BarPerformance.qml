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

    implicitWidth: Tokens.sizes.bar.innerWidth
    implicitHeight: layout.implicitHeight + Tokens.padding.extraSmall * 2

    color: Colours.tPalette.m3surfaceContainer
    radius: Tokens.rounding.full

    ServiceRef {
        service: Cpu
    }

    ServiceRef {
        service: Memory
    }

    ColumnLayout {
        id: layout

        anchors.centerIn: parent
        spacing: Tokens.spacing.extraSmall

        Item {
            Layout.alignment: Qt.AlignHCenter
            implicitWidth: 26
            implicitHeight: 26

            CircularProgress {
                anchors.fill: parent
                fgColour: (Cpu.temperature ?? 0) > 85 ? Colours.palette.m3error : Colours.palette.m3primary
                strokeWidth: 2
                value: Cpu.percentage ?? 0
            }

            MaterialIcon {
                anchors.centerIn: parent
                text: "memory"
                fontStyle: Tokens.font.icon.small
                color: (Cpu.temperature ?? 0) > 85 ? Colours.palette.m3error : Colours.palette.m3primary
            }
        }

        StyledText {
            Layout.alignment: Qt.AlignHCenter
            text: `${Math.round((Cpu.percentage ?? 0) * 100)}%`
            font: Tokens.font.body.builders.extraSmall.size(9).weight(Font.Bold).build()
            color: Colours.palette.m3onSurfaceVariant
        }
    }
}

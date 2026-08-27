pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import qs.components
import qs.services
import qs.modules.dashboard.dash as DashWidgets

ColumnLayout {
    id: root

    readonly property ScreenState screenState: ShellState.forActive()

    implicitWidth: 300
    spacing: Tokens.spacing.small

    StyledRect {
        Layout.fillWidth: true
        implicitHeight: timeHeader.implicitHeight + Tokens.padding.medium * 2
        radius: Tokens.rounding.large
        color: Colours.tPalette.m3surfaceContainer

        ColumnLayout {
            id: timeHeader
            anchors.centerIn: parent
            spacing: 2

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: Tokens.spacing.extraSmall

                StyledText {
                    text: `${Time.hourStr}:${Time.minuteStr}`
                    font: Tokens.font.clock.size(28).weight(Font.DemiBold).build()
                    color: Colours.palette.m3primary
                }

                Loader {
                    asynchronous: true
                    active: GlobalConfig.services.useTwelveHourClock && Time.amPmStr.length > 0
                    visible: active

                    sourceComponent: StyledText {
                        text: Time.amPmStr.toUpperCase()
                        font: Tokens.font.body.builders.small.weight(Font.Bold).build()
                        color: Colours.palette.m3secondary
                        Layout.alignment: Qt.AlignBottom
                        Layout.bottomMargin: 4
                    }
                }
            }

            StyledText {
                Layout.alignment: Qt.AlignHCenter
                text: Time.format("dddd, MMMM d")
                font: Tokens.font.body.small
                color: Colours.palette.m3onSurfaceVariant
            }
        }
    }

    DashWidgets.Calendar {
        id: calendar
        Layout.fillWidth: true
        screenState: root.screenState
    }
}

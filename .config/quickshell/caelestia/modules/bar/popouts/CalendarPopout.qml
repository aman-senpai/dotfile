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

    implicitWidth: 320
    spacing: Tokens.spacing.small

    Component.onCompleted: Weather.reload()

    // 1. Time & Date Header
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
                text: Time.format("dddd, MMMM d, yyyy")
                font: Tokens.font.body.small
                color: Colours.palette.m3onSurfaceVariant
            }
        }
    }

    // 2. Weather Details Card
    StyledRect {
        Layout.fillWidth: true
        implicitHeight: weatherLayout.implicitHeight + Tokens.padding.medium * 2
        radius: Tokens.rounding.large
        color: Colours.tPalette.m3surfaceContainer

        ColumnLayout {
            id: weatherLayout
            anchors.fill: parent
            anchors.margins: Tokens.padding.medium
            spacing: Tokens.spacing.extraSmall

            RowLayout {
                Layout.fillWidth: true
                spacing: Tokens.spacing.medium

                MaterialIcon {
                    text: Weather.icon
                    fontStyle: Tokens.font.icon.builders.extraLarge.scale(1.5).build()
                    color: Colours.palette.m3secondary
                    animate: true
                    Layout.alignment: Qt.AlignVCenter
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 0

                    RowLayout {
                        spacing: Tokens.spacing.extraSmall

                        StyledText {
                            text: Weather.temp
                            font: Tokens.font.title.builders.large.weight(Font.Bold).build()
                            color: Colours.palette.m3primary
                        }

                        StyledText {
                            text: Weather.description
                            font: Tokens.font.body.medium
                            color: Colours.palette.m3onSurfaceVariant
                            Layout.alignment: Qt.AlignVCenter
                        }
                    }

                    StyledText {
                        text: Weather.city ? Weather.city : qsTr("Current Location")
                        font: Tokens.font.body.small
                        color: Colours.palette.m3tertiary
                    }
                }
            }

            StyledRect {
                Layout.fillWidth: true
                implicitHeight: 1
                color: Colours.palette.m3outlineVariant
                Layout.topMargin: 2
                Layout.bottomMargin: 2
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Tokens.spacing.small

                Row {
                    spacing: 4
                    MaterialIcon {
                        text: "thermostat"
                        fontStyle: Tokens.font.icon.small
                        color: Colours.palette.m3primary
                    }
                    StyledText {
                        text: qsTr("Feels: %1").arg(Weather.feelsLike)
                        font: Tokens.font.body.builders.small.scale(0.9).build()
                        color: Colours.palette.m3onSurfaceVariant
                    }
                }

                Item { Layout.fillWidth: true }

                Row {
                    spacing: 4
                    MaterialIcon {
                        text: "water_drop"
                        fontStyle: Tokens.font.icon.small
                        color: Colours.palette.m3secondary
                    }
                    StyledText {
                        text: `${Weather.humidity}%`
                        font: Tokens.font.body.builders.small.scale(0.9).build()
                        color: Colours.palette.m3onSurfaceVariant
                    }
                }

                Item { Layout.fillWidth: true }

                Row {
                    spacing: 4
                    MaterialIcon {
                        text: "air"
                        fontStyle: Tokens.font.icon.small
                        color: Colours.palette.m3tertiary
                    }
                    StyledText {
                        text: `${Math.round(Weather.windSpeed)} km/h`
                        font: Tokens.font.body.builders.small.scale(0.9).build()
                        color: Colours.palette.m3onSurfaceVariant
                    }
                }
            }
        }
    }

    // 3. Interactive Calendar
    DashWidgets.Calendar {
        id: calendar
        Layout.fillWidth: true
        screenState: root.screenState
    }
}

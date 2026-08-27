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
    property bool weatherExpanded: false

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

    // 2. Expandable Weather Details Card
    StyledRect {
        id: weatherCard

        Layout.fillWidth: true
        implicitHeight: weatherLayout.implicitHeight + Tokens.padding.medium * 2
        radius: Tokens.rounding.large
        color: Colours.tPalette.m3surfaceContainer
        clip: true

        Behavior on implicitHeight {
            Anim {
                type: Anim.DefaultSpatial
            }
        }

        ColumnLayout {
            id: weatherLayout
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: Tokens.padding.medium
            spacing: Tokens.spacing.extraSmall

            // Clickable Header to Toggle Expansion
            Item {
                Layout.fillWidth: true
                implicitHeight: headerRow.implicitHeight

                StateLayer {
                    radius: Tokens.rounding.medium
                    onClicked: root.weatherExpanded = !root.weatherExpanded
                }

                RowLayout {
                    id: headerRow
                    anchors.fill: parent
                    spacing: Tokens.spacing.medium

                    MaterialIcon {
                        text: Weather.icon
                        fontStyle: Tokens.font.icon.builders.extraLarge.scale(1.4).build()
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

                    MaterialIcon {
                        text: root.weatherExpanded ? "expand_less" : "expand_more"
                        fontStyle: Tokens.font.icon.medium
                        color: Colours.palette.m3onSurfaceVariant
                        Layout.alignment: Qt.AlignVCenter
                    }
                }
            }

            // Quick Stats Row (Feels Like, Humidity, Wind)
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

            // Expandable Detailed Forecast Section
            Loader {
                Layout.fillWidth: true
                active: root.weatherExpanded
                visible: active

                sourceComponent: ColumnLayout {
                    spacing: Tokens.spacing.small
                    Layout.fillWidth: true
                    Layout.topMargin: Tokens.spacing.extraSmall

                    StyledRect {
                        Layout.fillWidth: true
                        implicitHeight: 1
                        color: Colours.palette.m3outlineVariant
                    }

                    // Sun times
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: Tokens.spacing.medium

                        Row {
                            spacing: 4
                            MaterialIcon {
                                text: "wb_twilight"
                                fontStyle: Tokens.font.icon.small
                                color: Colours.palette.m3tertiary
                            }
                            StyledText {
                                text: qsTr("Sunrise: %1").arg(Weather.sunrise)
                                font: Tokens.font.body.small
                                color: Colours.palette.m3onSurfaceVariant
                            }
                        }

                        Item { Layout.fillWidth: true }

                        Row {
                            spacing: 4
                            MaterialIcon {
                                text: "bedtime"
                                fontStyle: Tokens.font.icon.small
                                color: Colours.palette.m3tertiary
                            }
                            StyledText {
                                text: qsTr("Sunset: %1").arg(Weather.sunset)
                                font: Tokens.font.body.small
                                color: Colours.palette.m3onSurfaceVariant
                            }
                        }
                    }

                    // Hourly Forecast Title
                    StyledText {
                        text: qsTr("Hourly Forecast")
                        font: Tokens.font.body.builders.small.weight(Font.DemiBold).build()
                        color: Colours.palette.m3primary
                        Layout.topMargin: 2
                    }

                    // Hourly Forecast Row
                    Flickable {
                        Layout.fillWidth: true
                        implicitHeight: 70
                        contentWidth: hourlyRow.implicitWidth
                        flickableDirection: Flickable.HorizontalFlick
                        clip: true

                        RowLayout {
                            id: hourlyRow
                            spacing: Tokens.spacing.extraSmall

                            Repeater {
                                model: Weather.hourlyForecast ? Math.min(8, Weather.hourlyForecast.length) : 0

                                delegate: StyledRect {
                                    required property int index
                                    readonly property var hourData: Weather.hourlyForecast[index]

                                    implicitWidth: 46
                                    implicitHeight: 66
                                    radius: Tokens.rounding.small
                                    color: Colours.palette.m3surface

                                    ColumnLayout {
                                        anchors.centerIn: parent
                                        spacing: 1

                                        StyledText {
                                            Layout.alignment: Qt.AlignHCenter
                                            text: hourData ? `${hourData.hour}:00` : ""
                                            font: Tokens.font.body.builders.extraSmall.size(9).build()
                                            color: Colours.palette.m3onSurfaceVariant
                                        }

                                        MaterialIcon {
                                            Layout.alignment: Qt.AlignHCenter
                                            text: hourData ? hourData.icon : "cloud"
                                            fontStyle: Tokens.font.icon.small
                                            color: Colours.palette.m3secondary
                                        }

                                        StyledText {
                                            Layout.alignment: Qt.AlignHCenter
                                            text: hourData ? `${hourData.tempC}°` : ""
                                            font: Tokens.font.body.builders.small.weight(Font.Medium).size(10).build()
                                            color: Colours.palette.m3primary
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Daily Forecast Title
                    StyledText {
                        text: qsTr("5-Day Forecast")
                        font: Tokens.font.body.builders.small.weight(Font.DemiBold).build()
                        color: Colours.palette.m3primary
                        Layout.topMargin: 2
                    }

                    // Daily Forecast List
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 3

                        Repeater {
                            model: Weather.forecast ? Math.min(5, Weather.forecast.length) : 0

                            delegate: RowLayout {
                                required property int index
                                readonly property var dayData: Weather.forecast[index]

                                Layout.fillWidth: true
                                spacing: Tokens.spacing.small

                                StyledText {
                                    text: index === 0 ? qsTr("Today") : (dayData ? new Date(dayData.date).toLocaleDateString(Qt.locale(), "ddd") : "")
                                    font: Tokens.font.body.builders.small.weight(index === 0 ? Font.Bold : Font.Normal).build()
                                    color: index === 0 ? Colours.palette.m3primary : Colours.palette.m3onSurface
                                    Layout.preferredWidth: 46
                                }

                                MaterialIcon {
                                    text: dayData ? dayData.icon : "cloud"
                                    fontStyle: Tokens.font.icon.small
                                    color: Colours.palette.m3secondary
                                }

                                StyledText {
                                    text: dayData ? Weather.description : ""
                                    font: Tokens.font.body.builders.small.scale(0.85).build()
                                    color: Colours.palette.m3onSurfaceVariant
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }

                                StyledText {
                                    text: dayData ? `${Weather.formatTemp(dayData.minTempC).slice(0, -1)} / ${Weather.formatTemp(dayData.maxTempC)}` : ""
                                    font: Tokens.font.body.builders.small.weight(Font.Medium).build()
                                    color: Colours.palette.m3tertiary
                                    Layout.alignment: Qt.AlignRight
                                }
                            }
                        }
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

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Caelestia
import Caelestia.Config
import Caelestia.Services
import qs.components
import qs.components.controls
import qs.components.widgets
import qs.components.filedialog
import qs.services
import qs.utils
import qs.modules.dashboard.dash as DashWidgets

Item {
    id: root

    required property Props props
    required property ScreenState screenState

    readonly property FileDialog facePicker: FileDialog {
        title: qsTr("Select a profile picture")
        filterLabel: qsTr("Image files")
        filters: Images.validImageExtensions
        onAccepted: path => {
            if (CUtils.copyFile(Qt.resolvedUrl(path), Qt.resolvedUrl(`${Paths.home}/.face`)))
                Quickshell.execDetached(["notify-send", "-a", "caelestia-shell", "-u", "low", "-h", `STRING:image-path:${path}`, "Profile picture changed", `Profile picture changed to ${Paths.shortenHome(path)}`]);
            else
                Quickshell.execDetached(["notify-send", "-a", "caelestia-shell", "-u", "critical", "Unable to change profile picture", `Failed to change profile picture to ${Paths.shortenHome(path)}`]);
        }
    }

    Flickable {
        id: flickable

        anchors.fill: parent
        flickableDirection: Flickable.VerticalFlick
        contentWidth: width
        contentHeight: mainCol.implicitHeight

        StyledScrollBar.vertical: StyledScrollBar {
            flickable: flickable
        }

        ColumnLayout {
            id: mainCol

            width: flickable.width
            spacing: Tokens.spacing.medium

            // 1. User Profile & Resource Rings
            StyledRect {
                Layout.fillWidth: true
                implicitHeight: 110
                radius: Tokens.rounding.large
                color: Colours.tPalette.m3surfaceContainer

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: Tokens.padding.small
                    spacing: Tokens.spacing.small

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        DashWidgets.User {
                            id: user
                            screenState: root.screenState
                            facePicker: root.facePicker
                        }
                    }

                    DashWidgets.Resources {
                        id: resources
                        Layout.preferredWidth: resources.implicitWidth
                        Layout.fillHeight: true
                    }
                }
            }

            // 2. Quick Settings Toggles
            StyledRect {
                Layout.fillWidth: true
                implicitHeight: toggleRow.implicitHeight + Tokens.padding.small * 2
                radius: Tokens.rounding.large
                color: Colours.tPalette.m3surfaceContainer

                RowLayout {
                    id: toggleRow
                    anchors.centerIn: parent
                    spacing: Tokens.spacing.small

                    IconButton {
                        icon: "wifi"
                        isToggle: true
                        isRound: true
                        shapeMorph: true
                        checked: Nmcli.wifiEnabled
                        onClicked: Nmcli.toggleWifi()
                    }

                    IconButton {
                        icon: "bluetooth"
                        isToggle: true
                        isRound: true
                        shapeMorph: true
                        checked: Bluetooth.defaultAdapter?.enabled ?? false // qmllint disable unresolved-type
                        onClicked: {
                            const adapter = Bluetooth.defaultAdapter; // qmllint disable unresolved-type
                            if (adapter)
                                adapter.enabled = !adapter.enabled;
                        }
                    }

                    IconButton {
                        icon: "mic"
                        isToggle: true
                        isRound: true
                        shapeMorph: true
                        checked: !Audio.sourceMuted
                        onClicked: {
                            const audio = Audio.source?.audio;
                            if (audio)
                                audio.muted = !audio.muted;
                        }
                    }

                    IconButton {
                        icon: "notifications_off"
                        isToggle: true
                        isRound: true
                        shapeMorph: true
                        checked: Notifs.dnd
                        onClicked: Notifs.dnd = !Notifs.dnd
                    }

                    IconButton {
                        icon: "vpn_key"
                        isToggle: true
                        isRound: true
                        shapeMorph: true
                        checked: VPN.connected
                        onClicked: VPN.toggle()
                    }
                }
            }

            // 3. Live Media Player Card
            StyledRect {
                Layout.fillWidth: true
                implicitHeight: mediaLayout.implicitHeight + Tokens.padding.medium * 2
                radius: Tokens.rounding.large
                color: Colours.tPalette.m3surfaceContainer

                RowLayout {
                    id: mediaLayout
                    anchors.fill: parent
                    anchors.margins: Tokens.padding.medium
                    spacing: Tokens.spacing.medium

                    CoverArt {
                        id: cover
                        Layout.preferredWidth: 56
                        Layout.preferredHeight: 56
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2

                        StyledText {
                            text: (Players.active?.trackTitle ?? qsTr("No media playing")) || qsTr("Unknown title")
                            font: Tokens.font.body.builders.medium.weight(Font.DemiBold).build()
                            color: Colours.palette.m3primary
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }

                        StyledText {
                            text: (Players.active?.trackArtist ?? "") || (Players.active?.trackAlbum ?? qsTr("Play something to begin"))
                            font: Tokens.font.body.small
                            color: Colours.palette.m3onSurfaceVariant
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }

                        RowLayout {
                            spacing: Tokens.spacing.extraSmall
                            Layout.topMargin: 2

                            IconButton {
                                type: IconButton.Tonal
                                icon: "skip_previous"
                                isRound: true
                                shapeMorph: true
                                disabled: !Players.active?.canGoPrevious
                                onClicked: Players.active?.previous()
                            }

                            IconButton {
                                icon: Players.active?.isPlaying ? "pause" : "play_arrow"
                                isRound: true
                                shapeMorph: true
                                checked: Players.active?.isPlaying ?? false
                                disabled: !Players.active?.canTogglePlaying
                                onClicked: Players.active?.togglePlaying()
                            }

                            IconButton {
                                type: IconButton.Tonal
                                icon: "skip_next"
                                isRound: true
                                shapeMorph: true
                                disabled: !Players.active?.canGoNext
                                onClicked: Players.active?.next()
                            }
                        }
                    }
                }
            }

            // 4. Performance Metrics Card (CPU / GPU / Thermals)
            StyledRect {
                Layout.fillWidth: true
                implicitHeight: perfLayout.implicitHeight + Tokens.padding.medium * 2
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
                    id: perfLayout

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

            // 5. Notifications Dock Header & List
            StyledRect {
                Layout.fillWidth: true
                implicitHeight: 300
                radius: Tokens.rounding.large
                color: Colours.tPalette.m3surfaceContainerLow

                NotifDock {
                    objectName: "sidebarNotifications"
                    props: root.props
                    screenState: root.screenState
                }
            }
        }
    }
}

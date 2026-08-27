pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Caelestia
import Caelestia.Config
import qs.components
import qs.components.filedialog
import qs.services
import qs.utils
import qs.components.controls
import qs.components.widgets
import qs.modules.dashboard.dash as DashWidgets
import qs.modules.utilities.cards as UtilCards

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

    ColumnLayout {
        id: layout

        anchors.fill: parent
        spacing: Tokens.spacing.medium

        // 1. User Profile & System Resources Card
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

        // 2. Media Player Card
        StyledRect {
            Layout.fillWidth: true
            implicitHeight: mediaLayout.implicitHeight + Tokens.padding.medium * 2
            radius: Tokens.rounding.large
            color: Colours.tPalette.m3surfaceContainer
            visible: Players.active !== null

            RowLayout {
                id: mediaLayout
                anchors.fill: parent
                anchors.margins: Tokens.padding.medium
                spacing: Tokens.spacing.medium

                CoverArt {
                    id: cover
                    Layout.preferredWidth: 64
                    Layout.preferredHeight: 64
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2

                    StyledText {
                        text: (Players.active?.trackTitle ?? qsTr("No media")) || qsTr("Unknown title")
                        font: Tokens.font.body.builders.medium.weight(Font.DemiBold).build()
                        color: Colours.palette.m3primary
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }

                    StyledText {
                        text: (Players.active?.trackArtist ?? "") || (Players.active?.trackAlbum ?? "")
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

        // 3. Quick Toggles
        Loader {
            Layout.fillWidth: true
            asynchronous: true
            active: true
            visible: active

            sourceComponent: StyledRect {
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
        }

        // 4. Notifications Dock
        StyledRect {
            Layout.fillWidth: true
            Layout.fillHeight: true
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

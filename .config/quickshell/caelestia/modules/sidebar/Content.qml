pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Templates
import Caelestia
import Caelestia.Config
import qs.components
import qs.components.controls
import qs.components.widgets
import qs.components.filedialog
import qs.services
import qs.utils
import qs.modules.dashboard.dash as DashWidgets
import qs.modules.dashboard as DashModules

Item {
    id: root

    required property Props props
    required property ScreenState screenState

    property int activeTab: 0

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

        // 1. Top Header: User Profile & Resource Rings
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

        // 3. Tab Switcher (Notifications, Performance, Media)
        StyledRect {
            Layout.fillWidth: true
            implicitHeight: tabRow.implicitHeight + Tokens.padding.extraSmall * 2
            radius: Tokens.rounding.large
            color: Colours.tPalette.m3surfaceContainer

            RowLayout {
                id: tabRow
                anchors.fill: parent
                anchors.margins: Tokens.padding.extraSmall
                spacing: Tokens.spacing.extraSmall

                SidebarTabButton {
                    text: qsTr("Alerts")
                    iconName: "notifications"
                    tabIndex: 0
                }

                SidebarTabButton {
                    text: qsTr("Performance")
                    iconName: "speed"
                    tabIndex: 1
                }

                SidebarTabButton {
                    text: qsTr("Media")
                    iconName: "queue_music"
                    tabIndex: 2
                }
            }
        }

        // 4. Tab Content Area
        StyledRect {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: Tokens.rounding.large
            color: Colours.tPalette.m3surfaceContainerLow
            clip: true

            // Tab 0: Notifications Dock
            Loader {
                anchors.fill: parent
                active: root.activeTab === 0
                visible: active

                sourceComponent: NotifDock {
                    objectName: "sidebarNotifications"
                    props: root.props
                    screenState: root.screenState
                }
            }

            // Tab 1: Performance View (Scrollable)
            Loader {
                anchors.fill: parent
                active: root.activeTab === 1
                visible: active

                sourceComponent: Flickable {
                    anchors.fill: parent
                    anchors.margins: Tokens.padding.medium
                    contentWidth: width
                    contentHeight: perfContent.implicitHeight
                    flickableDirection: Flickable.VerticalFlick
                    clip: true

                    DashModules.Performance {
                        id: perfContent
                        width: parent.width
                    }
                }
            }

            // Tab 2: Media Player View
            Loader {
                anchors.fill: parent
                active: root.activeTab === 2
                visible: active

                sourceComponent: Flickable {
                    anchors.fill: parent
                    anchors.margins: Tokens.padding.medium
                    contentWidth: width
                    contentHeight: mediaContent.implicitHeight
                    flickableDirection: Flickable.VerticalFlick
                    clip: true

                    DashModules.Media {
                        id: mediaContent
                        width: parent.width
                        screenState: root.screenState
                    }
                }
            }
        }
    }

    component SidebarTabButton: Item {
        id: tabBtn

        required property string text
        required property string iconName
        required property int tabIndex

        readonly property bool isCurrent: root.activeTab === tabIndex

        Layout.fillWidth: true
        Layout.preferredWidth: 1
        implicitHeight: 36

        StateLayer {
            radius: Tokens.rounding.medium
            color: tabBtn.isCurrent ? Colours.palette.m3primaryContainer : Colours.palette.m3surfaceContainerHigh
            onClicked: root.activeTab = tabBtn.tabIndex
        }

        RowLayout {
            anchors.centerIn: parent
            spacing: Tokens.spacing.extraSmall

            MaterialIcon {
                text: tabBtn.iconName
                fontStyle: Tokens.font.icon.small
                color: tabBtn.isCurrent ? Colours.palette.m3onPrimaryContainer : Colours.palette.m3onSurfaceVariant
            }

            StyledText {
                text: tabBtn.text
                font: Tokens.font.body.builders.small.weight(tabBtn.isCurrent ? Font.DemiBold : Font.Normal).build()
                color: tabBtn.isCurrent ? Colours.palette.m3onPrimaryContainer : Colours.palette.m3onSurfaceVariant
            }
        }
    }
}

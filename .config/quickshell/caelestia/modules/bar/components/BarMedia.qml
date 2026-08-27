pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import qs.components
import qs.components.controls
import qs.components.widgets
import qs.services

StyledRect {
    id: root

    property real playerProgress: {
        const active = Players.active;
        return active?.length ? (active.position % active.length) / active.length : 0;
    }

    readonly property bool hasMedia: Players.active !== null

    implicitWidth: Tokens.sizes.bar.innerWidth
    implicitHeight: layout.implicitHeight + Tokens.padding.extraSmall * 2

    color: Colours.tPalette.m3surfaceContainer
    radius: Tokens.rounding.full
    clip: true

    StateLayer {
        anchors.fill: parent
        radius: Tokens.rounding.full
        onClicked: Players.active?.togglePlaying()
    }

    ColumnLayout {
        id: layout

        anchors.centerIn: parent
        spacing: 2

        Item {
            Layout.alignment: Qt.AlignHCenter
            implicitWidth: 28
            implicitHeight: 28

            CircularProgress {
                anchors.fill: parent
                fgColour: Colours.palette.m3primary
                strokeWidth: 2
                value: root.playerProgress
            }

            MaterialIcon {
                anchors.centerIn: parent
                text: Players.active?.isPlaying ? "pause" : (root.hasMedia ? "play_arrow" : "queue_music")
                fontStyle: Tokens.font.icon.small
                color: Players.active?.isPlaying ? Colours.palette.m3primary : Colours.palette.m3onSurfaceVariant
                animate: true
            }
        }
    }
}

pragma ComponentBehavior: Bound

import "dash"
import QtQuick.Layouts
import Caelestia.Config
import qs.components
import qs.components.filedialog
import qs.services

RowLayout {
    id: root

    required property ScreenState screenState
    required property FileDialog facePicker

    spacing: Tokens.spacing.medium

    Rect {
        Layout.preferredWidth: Tokens.sizes.dashboard.userWidth
        Layout.preferredHeight: 120
        radius: Tokens.rounding.extraLarge

        User {
            id: user
            screenState: root.screenState
            facePicker: root.facePicker
        }
    }

    Rect {
        Layout.preferredWidth: Tokens.sizes.dashboard.weatherWidth
        Layout.preferredHeight: 120
        radius: Tokens.rounding.extraLarge * 1.5

        SmallWeather {
            id: weather
        }
    }

    Rect {
        Layout.preferredWidth: resources.implicitWidth
        Layout.preferredHeight: 120
        radius: Tokens.rounding.large

        Resources {
            id: resources
        }
    }

    Rect {
        Layout.preferredWidth: media.implicitWidth
        Layout.preferredHeight: 120
        radius: Tokens.rounding.extraLarge * 2

        Media {
            id: media
        }
    }

    component Rect: StyledRect {
        color: Colours.tPalette.m3surfaceContainer
    }
}

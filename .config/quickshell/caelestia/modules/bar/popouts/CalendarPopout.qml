pragma ComponentBehavior: Bound

import QtQuick
import Caelestia.Config
import qs.components
import qs.services
import qs.modules.dashboard.dash as DashWidgets

Item {
    id: root

    readonly property ScreenState screenState: ShellState.forActive()

    implicitWidth: 300
    implicitHeight: calendar.implicitHeight

    DashWidgets.Calendar {
        id: calendar
        anchors.fill: parent
        screenState: root.screenState
    }
}

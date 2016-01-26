import QtQuick 2.4
import QtQuick.Window 2.1
import QtLocation 5.5
import QtPositioning 5.5
import QtQuick.Controls 1.4

import "qrc:/pages"
import "qrc:/components"

Window {
    id: app
    width: 1024
    height: 600
    visible: true
    visibility: Window.AutomaticVisibility

    // Style props:

    property color colorDarkFg: "#636363"
    property color colorDarkBg: "#636363"
    property color colorLightFg: Qt.rgba(0.6, 0.6, 0.6, 1.0)
    property color colorSelectedBg: "#e45000"
    property color colorGreenBg: "#80c342"

    property FontMetrics fontBig: FontMetrics { font.family: "arial"; font.pixelSize: 20 }
    property FontMetrics fontNormal: FontMetrics { font.family: "arial"; font.pixelSize: 15 }
    property FontMetrics fontSmall: FontMetrics { font.family: "verdana"; font.pixelSize: 14 }

    property real margin: 10
    property real spacingHor: 40
    property real spacingVer: 20
    property real contentLeftMargin: 50

    // Global API:

    property Model model: Model{}
    property AppPage currentView: park0DetailsPage
    property alias mainView: mainPage
    property alias park0DetailsView: park0DetailsPage
    property alias park1DetailsView: park1DetailsPage
    property alias settingsView: settingsPage

    MainToolbar {
    }

    MainPage {
        id: mainPage
    }

    ParkDetailsPage {
        id: park0DetailsPage
        parkId: 0
    }

    ParkDetailsPage {
        id: park1DetailsPage
        parkId: 1
    }

    SettingsPage {
        id: settingsPage
    }
}

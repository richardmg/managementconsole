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
    property color colorLightBg: "#f6f6f6"
    property color colorSelectedBg: "#e45000"
    property color colorGreenBg: "#80c342"

    property FontMetrics fontBig: FontMetrics { font.family: "arial"; font.pixelSize: 20 }
    property FontMetrics fontNormal: FontMetrics { font.family: "arial"; font.pixelSize: 15 }
    property FontMetrics fontSmall: FontMetrics { font.family: "arial"; font.pixelSize: 14 }

    property real margin: 10
    property real spacingHor: 40
    property real spacingVer: 20
    property real contentLeftMargin: 50

    // Global API:

    property alias model: model
    property AppPage currentView: mainPage
    property alias mainView: mainPage
    property alias detailPages: detailPages
    property alias settingsView: settingsPage

    Model {
        id: model
    }

    MainToolbar {
    }

    MainPage {
        id: mainPage
    }

    Repeater {
        id: detailPages
        model: app.model.current.descriptions.length
        ParkDetailsPage {
            modelIndex: index
        }
    }

    SettingsPage {
        id: settingsPage
    }
}

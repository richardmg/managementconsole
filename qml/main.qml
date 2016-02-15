import QtQuick 2.4
import QtQuick.Window 2.1
import QtLocation 5.5
import QtPositioning 5.5
import QtQuick.Controls 1.4

import "qrc:/model/qml"
import "qrc:/pages/qml"
import "qrc:/components/qml"

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

    property FontMetrics fontA: FontMetrics { font.family: "arial"; font.pixelSize: 20 }
    property FontMetrics fontB: FontMetrics { font.family: "arial"; font.pixelSize: 16 }
    property FontMetrics fontC: FontMetrics { font.family: "arial"; font.pixelSize: 20; font.bold: true }
    property FontMetrics fontD: FontMetrics { font.family: "arial"; font.pixelSize: 18; font.bold: true }
    property FontMetrics fontE: FontMetrics { font.family: "arial"; font.pixelSize: 12 }
    property FontMetrics fontF: FontMetrics { font.family: "arial"; font.pixelSize: 22 }
    property FontMetrics fontG: FontMetrics { font.family: "arial"; font.pixelSize: 26; font.bold: true }
    property FontMetrics fontH: FontMetrics { font.family: "arial"; font.pixelSize: 16; font.bold: true }

    property real margin: 10
    property real spacingHor: 40
    property real spacingVer: 20
    property real contentLeftMargin: 50

    // Global accessors:

    property TopLevelPage currentPage: mainViewPage

    property alias model: model
    property alias mainViewPage: mainViewPage
    property alias detailPages: detailPages
    property alias settingsView: settingsPage

    Model {
        id: model
    }

    MainToolbar {
    }

    MainViewPage {
        id: mainViewPage
    }

    Repeater {
        id: detailPages
        model: app.model.currentModel.descriptions.length
        ParkingLotPage {
            modelIndex: index
        }
    }

    SettingsPage {
        id: settingsPage
    }
}

import QtQuick 2.4
import QtQuick.Window 2.1
import QtLocation 5.5
import QtPositioning 5.5
import QtQuick.Controls 1.4

import "model.js" as Model

Window {
    id: app
    width: 1024
    height: 600
    visible: true
    visibility: Window.AutomaticVisibility

    property color gColorDarkLine: Qt.rgba(0.3, 0.3, 0.3, 1.0)
    property color gColorLightLine: Qt.rgba(0.6, 0.6, 0.6, 1.0)
    property color gColorSelectedBg: Qt.rgba(0.9, 0.9, 0.9, 1.0)

    property FontMetrics gFontBig: FontMetrics { font.family: "verdana"; font.pixelSize: 24 }
    property FontMetrics gFontNormal: FontMetrics { font.family: "verdana"; font.pixelSize: 18 }
    property FontMetrics gFontSmall: FontMetrics { font.family: "verdana"; font.pixelSize: 14 }

    property alias mainView: mainView

    signal parkModelUpdated(int parkId)

    Button {
        text: "Load data"
        width: 100
        height: 50
        onClicked: {
            Model.dataSource = Model.kFakeDataSource
            parkModelUpdated(0)
            parkModelUpdated(1)
            mainView.parkMap.centerOnAllParks()
        }
    }

    MainView {
        id: mainView
        anchors.fill: parent
        anchors.margins: 10
        anchors.topMargin: 100
    }
}

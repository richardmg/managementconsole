import QtQuick 2.4
import QtQuick.Window 2.1
import QtLocation 5.5
import QtPositioning 5.5
import QtQuick.Controls 1.4

import "model.js" as Model

Window {
    id: root
    width: 1024
    height: 600
    visible: true
    visibility: Window.AutomaticVisibility

    // Layout guide lines

    property int xContent1Start: 10
    property int xContent1Stop: 600
    property int xContent2Start: 610
    property int xContent2Stop: width - 10

    property int yButtonStart: 10
    property int yButtonStop: 100
    property int yContent1Start: 110
    property int yContent1Stop: 350
    property int yContent2Start: yContent1Start + (yContent2Stop - yContent1Start + 20) / 2
    property int yContent2Stop: height - 10

    property color appDarkLine: Qt.rgba(0.3, 0.3, 0.3, 1.0)
    property color appLightLine: Qt.rgba(0.6, 0.6, 0.6, 1.0)

    property FontMetrics appBigFont: FontMetrics { font.family: "verdana"; font.pixelSize: 24 }
    property FontMetrics appNormalFont: FontMetrics { font.family: "verdana"; font.pixelSize: 18 }
    property FontMetrics appSmallFont: FontMetrics { font.family: "verdana"; font.pixelSize: 14 }

    // Global object accessors

    property alias gParkMap: parkMap
    property int gSelectedParkId: -1

    signal parkModelUpdated(int parkId)

    Button {
        text: "Load data"
        onClicked: {
            Model.dataSource = Model.kFakeDataSource
            parkModelUpdated(0)
            parkModelUpdated(1)
            gParkMap.centerOnAllParks()
        }
    }

    ParkMap {
        id: parkMap
        x: xContent1Start
        y: yContent1Start
        width: xContent1Stop - x
        height: yContent2Stop - y
    }

    ParkLog {
        id: parkA
        x: xContent2Start
        y: yContent1Start
        width: xContent2Stop - x
        height: yContent1Stop - y
        parkId: 0
    }

    ParkLog {
        id: parkB
        x: xContent2Start
        y: yContent2Start
        width: xContent2Stop - x
        height: yContent2Stop - y
        parkId: 1
    }

    function gSelectPark(parkId)
    {
        var prev = gParkMap.getOverlay(gSelectedParkId)
        if (prev)
            prev.highlight(false)

        var curr = gParkMap.getOverlay(parkId)
        if (curr) {
            curr.highlight(true)
            gParkMap.centerOnAllParks()
            gSelectedParkId = parkId
        }
    }
}

import QtQuick 2.4
import QtQuick.Window 2.1
import QtLocation 5.5
import QtPositioning 5.5
import QtQuick.Controls 1.4

import "model.js" as Model

Item {
    property alias parkMap: parkMap
    property int selectedParkId: -1

    property real margin: 10
    property real splitX: 0.6
    property real splitY: 0.5

    ParkMap {
        id: parkMap
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width * splitX
    }

    ParkLog {
        id: parkA
        anchors.top: parent.top
        anchors.left: parkMap.right
        anchors.leftMargin: margin
        anchors.right: parent.right
        height: parent.height * splitY
        parkId: 0
    }

    ParkLog {
        id: parkB
        anchors.top: parkA.bottom
        anchors.topMargin: margin
        anchors.bottom: parent.bottom
        anchors.left: parkMap.right
        anchors.leftMargin: margin
        anchors.right: parent.right
        parkId: 1
    }
}

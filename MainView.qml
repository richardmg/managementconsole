import QtQuick 2.4
import QtQuick.Window 2.1
import QtLocation 5.5
import QtPositioning 5.5
import QtQuick.Controls 1.4

import "model.js" as Model

Item {
    property alias parkMap: parkMap
    property int selectedParkId: -1

    property real splitX: 0.5
    property real splitY: 0.6

    ParkMap {
        id: parkMap
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width * splitY
    }

    ParkLog {
        id: parkA
        anchors.top: parent.top
        anchors.bottom: spacing.top
        anchors.left: parkMap.right
        anchors.right: parent.right
        anchors.margins: 10
        anchors.topMargin: 0
        parkId: 0
    }

    Item {
        id: spacing
        width: 10
        height: 10
        y: (parent.height - height) * splitX
    }

    ParkLog {
        id: parkB
        anchors.top: spacing.bottom
        anchors.bottom: parent.bottom
        anchors.left: parkMap.right
        anchors.right: parent.right
        anchors.margins: 10
        anchors.bottomMargin: 0
        parkId: 1
    }
}

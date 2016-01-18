import QtQuick 2.1
import QtQuick.Window 2.1
import QtLocation 5.5
import QtPositioning 5.5
import QtQuick.Controls 1.4

Window {
    width: 1024
    height: 600
    visible: true
    visibility: Window.AutomaticVisibility

    // Layout guide lines
    property int topLine1: 10
    property int topLine2: 100
    property int topLine3: height - 10

    property int leftLine1: 10
    property int leftLine2: 600
    property int leftLine3: 620

    ListModel {
        id: parkingLots
        ListElement {
            name: "Augustinerhof"
            latitude: 49.45370
            longitude: 11.07515
        }
        ListElement {
            name: "Karlstadt"
            latitude: 49.45297
            longitude: 11.08270
        }
        ListElement {
            name: "Adlerstrase"
            latitude: 49.45211
            longitude: 11.07700
        }
    }

    MapWithParkingLots {
        x: leftLine1
        y: topLine2
        width: leftLine2 - x
        height: topLine3 - y
        parkingLots: parkingLots
    }

}

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

    property var defaultLocation: nuremberg
    property int defaultZoomLevel: 16

    property var _overlayList: new Array

    Component.onCompleted: {
        // Create overlay items for all places listed in the parkinglots model
        for (var i = 0; i < parkinglots.count; ++i) {
            var data = parkinglots.get(i)
            var overlay = overlayParkingLotComp.createObject(map, { modelData: data })
            _overlayList.push(overlay)
        }

        // Workaround bug: map.fromCoordinate does not work unless a map is loaded.
        // And currently I cannot detect at which point that is ready.
        delayedUpdateOverlaysTimer.start()
    }

    /********************************************
      POIs
     ********************************************/

    Location {
        id: oslo
        coordinate {
            latitude: 59.9128
            longitude: 10.7386
        }
    }

    Location {
        id: nuremberg
        coordinate {
            latitude: 49.4531
            longitude: 11.0743
        }
    }

    ListModel {
        id: parkinglots
        ListElement {
            name: "Augustinerhof"
            latitude: 49.45370
            longitude: 11.07515
        }
        ListElement {
            name: "Karlstadt"
            latitude: 49.45370
            longitude: 11.07515
        }
    }

    /********************************************
      Map and overlay
     ********************************************/

    Map {
        id: map
        anchors.fill: parent
        plugin: Plugin { name: "osm" }
        center: defaultLocation.coordinate
        zoomLevel: defaultZoomLevel

        onCenterChanged: updateOverlays()
        onZoomLevelChanged: updateOverlays()
        onErrorChanged: print("error code:", error) // todo: show backup static map image

        MouseArea {
            anchors.fill: parent
            onClicked: {
                var clickedCoord = map.toCoordinate(Qt.point(mouse.x, mouse.y));
                print("lat:", clickedCoord.latitude, "lon:", clickedCoord.longitude, clickedCoord)
            }
        }

        Button {
            anchors.top: parent.top
            text: "Center"
            onClicked: {
                map.center = defaultLocation.coordinate
                map.zoomLevel = defaultZoomLevel
            }
        }
    }

    Timer {
        id: delayedUpdateOverlaysTimer
        interval: 100
        onTriggered: updateOverlays()
    }

    function updateOverlays()
    {
        if (!_overlayList) {
            // Work-around Map wrongly emits signals (onCenterChanged) before it's
            // completed, which makes us access variables (_overlayList) that is not yet ready.
            return
        }

        for (var i = 0; i < _overlayList.length; ++i)
            _overlayList[i].updateOverlay()
    }

    Component {
        id: overlayParkingLotComp
        Image {
            width: 80
            height: 80
            source: "qrc:/img/parkingsign.png"
            opacity: 0.2

            property var modelData

            function updateOverlay()
            {
                var coordinate = QtPositioning.coordinate(modelData.latitude, modelData.longitude)
                var pos = map.fromCoordinate(coordinate)
                x = pos.x - (width / 2)
                y = pos.y - (height / 2)
            }

            MouseArea {
                anchors.fill: parent
                onClicked: print("You clicked parking lot:", parkingLotId)
            }
        }
    }

    function createNativeOverlay(coord)
    {
        // Map overlays from QtLocation cannot have child items (and they scale
        // upon zoom), so we don't use them. But I leave this code section here
        // if for nothing else than showing this comment.
        var circle = parkingLotMapComp.createObject(map)
        circle.center = coord
        circle.radius = 20.0
        circle.color = 'white'
        circle.border.width = 1
        map.addMapItem(circle)
    }

}

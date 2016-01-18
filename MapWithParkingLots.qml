import QtQuick 2.1
import QtLocation 5.5
import QtPositioning 5.5
import QtQuick.Controls 1.4

Rectangle {
    property ListModel parkingLots
    property int startZoomLevel: 16
    property var startLocation: Location {
            id: nuremberg
            coordinate {
                latitude: 49.45284
                longitude: 11.07895
            }
        }

    property Component overlayComponent: Component {
        Image {
            width: 80
            height: 80
            source: "qrc:/img/parkingsign.png"

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
                onClicked: print("You clicked parking lot:", modelData.name)
            }
        }
    }

    //=====================================

    property var _overlayList: new Array

    Component.onCompleted: {
        // Create overlay items for all places listed in the parkingLots model
        for (var i = 0; i < parkingLots.count; ++i) {
            var data = parkingLots.get(i)
            var overlay = overlayComponent.createObject(map, { modelData: data })
            _overlayList.push(overlay)
        }

        // Workaround bug: map.fromCoordinate does not work unless a map is loaded.
        // And currently I cannot detect at which point that is ready.
        delayedUpdateOverlaysTimer.start()
    }

    Map {
        id: map
        anchors.fill: parent
        plugin: Plugin { name: "osm" }
        center: startLocation.coordinate
        zoomLevel: startZoomLevel

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
                map.center = startLocation.coordinate
                map.zoomLevel = startZoomLevel
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

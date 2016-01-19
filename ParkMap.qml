import QtQuick 2.1
import QtLocation 5.5
import QtPositioning 5.5
import QtQuick.Controls 1.4
import "model.js" as Model

Rectangle {
    property ListModel parks
    property alias zoomLevel: map.zoomLevel
    property alias center: map.center

    function centerOnPark(id)
    {
        var park = Model.getParkingLotModel(id)
        map.center = QtPositioning.coordinate(park.latitude, park.longitude)
        map.zoomLevel = 16
    }

    function centerOnAllParks()
    {
        map.fitViewportToMapItems()
    }

    property Component overlayComponent: Component {
        Image {
            width: 80
            height: 80
            source: "qrc:/img/parkingsign.png"

            property var parkModel

            function updateOverlay()
            {
                var coordinate = QtPositioning.coordinate(parkModel.latitude, parkModel.longitude)
                var pos = map.fromCoordinate(coordinate)
                // Only be visible if overlay is inside visible map
                visible = pos.x && pos.y
                if (visible) {
                    x = pos.x - (width / 2)
                    y = pos.y - (height / 2)
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: print("You clicked parking lot:", parkModel.parkName)
            }
        }
    }

    //=====================================

    property var _overlayList: new Array

    Component.onCompleted: {
        // Create overlay items for all places listed in the parks model

        var idArray = Model.getAllParkingLotIds()

        for (var i = 0; i < idArray.length; ++i) {
            var parkModel = Model.getParkingLotModel(idArray[i])
            // We create custom overlays since QtLocation overlays cannot have children
            var overlay = overlayComponent.createObject(map, { parkModel: parkModel })
            _overlayList.push(overlay)

            // ... but add dummy QtLocation overlays to simplify map centering:
            var overlay2 = Qt.createQmlObject('import QtLocation 5.3; MapCircle {}', map)
            overlay2.center = QtPositioning.coordinate(parkModel.latitude, parkModel.longitude)
            overlay2.radius = 100
            overlay2.opacity = 0
            map.addMapItem(overlay2)
        }

        centerOnAllParks()

        // Workaround bug: map.fromCoordinate does not work unless a map is loaded.
        // And currently I cannot detect at which point that is ready.
        delayedUpdateOverlaysTimer.start()
    }

    Map {
        id: map
        anchors.fill: parent
        plugin: Plugin { name: "osm" }
        zoomLevel: 16

        onCenterChanged: updateOverlays()
        onZoomLevelChanged: updateOverlays()
        onErrorChanged: print("error code:", error) // todo: show backup static map image

//        Behavior on center { NumberAnimation { duration: 1000 } }

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
            onClicked: centerOnAllParks()
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

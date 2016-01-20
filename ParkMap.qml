import QtQuick 2.1
import QtLocation 5.5
import QtPositioning 5.5
import QtQuick.Controls 1.4
import "model.js" as Model

Rectangle {
    property alias zoomLevel: map.zoomLevel
    property alias center: map.center
    property bool useAnimation: false

    property var _overlayList: new Array

    function centerOnPark(parkId)
    {
        var park = Model.getParkingLotModel(parkId)
        moveToLatLon(park.latitude, park.longitude)
        zoomLevel = 18
    }

    function centerOnAllParks()
    {
        map.fitViewportToMapItems()
    }

    function getOverlay(parkId)
    {
        for (var i = 0; i < _overlayList.length; ++i)
            if (_overlayList[i].parkModel.parkId === parkId)
                return _overlayList[i]
        return null
    }

    property Component overlayComponent: Component {
        Rectangle {
            width: 80
            height: 80
            radius: 5
            color: app.mainView.selectedParkId === parkModel.parkId ? "black" : "transparent"

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

            Image {
                anchors.fill: parent
                anchors.margins: 3
                source: "qrc:/img/parkingsign.png"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: app.mainView.selectedParkId = parkModel.parkId
            }
        }
    }

    //=====================================

    Connections {
        target: app
        onParkModelUpdated: recreateOverlay()
    }

    Component.onCompleted: {
        recreateOverlay()
        // Workaround bug: map.fromCoordinate does not work unless a map is loaded.
        // And currently I cannot detect at which point that is ready.
        delayedUpdateOverlaysTimer.start()
        centerOnAllParks()
    }

    function recreateOverlay()
    {
        for (var i = 0; i < _overlayList.length; ++i) {
            _overlayList[i].parent = null
            _overlayList[i].destroy()
        }

        _overlayList = new Array
        map.clearMapItems()

        var idArray = Model.getAllParkIds()

        for (i = 0; i < idArray.length; ++i) {
            var parkModel = Model.getParkingLotModel(idArray[i])
            if (parkModel.emptyParkModel)
                continue

            // We create custom overlays since QtLocation overlays cannot have children
            var overlay = overlayComponent.createObject(map, { parkModel: parkModel })
            overlay.updateOverlay()
            _overlayList.push(overlay)

            // ... but add dummy QtLocation overlays to simplify map centering:
            var overlay2 = Qt.createQmlObject('import QtLocation 5.3; MapCircle {}', map)
            overlay2.center = QtPositioning.coordinate(parkModel.latitude, parkModel.longitude)
            overlay2.radius = 100
            overlay2.opacity = 0
            map.addMapItem(overlay2)
        }
    }

    Map {
        id: map
        anchors.fill: parent
        plugin: Plugin { name: "osm" }
        zoomLevel: 16

        onCenterChanged: updateOverlays()
        onZoomLevelChanged: updateOverlays()
        onErrorChanged: print("error code:", error) // todo: show backup static map image
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

    // Experimental
    // Map.center does not support animations by default, so we need some extra properties
    property real _centerX
    property real _centerY
    on_CenterXChanged: map.center = QtPositioning.coordinate(_centerX, _centerY)
    on_CenterYChanged: map.center = QtPositioning.coordinate(_centerX, _centerY)
    Behavior on _centerX { enabled: useAnimation; NumberAnimation{ easing.type: Easing.OutCubic } }
    Behavior on _centerY { enabled: useAnimation; NumberAnimation{ easing.type: Easing.OutCubic } }
    Behavior on zoomLevel { enabled: useAnimation; NumberAnimation{ easing.type: Easing.OutCubic } }

    function moveToLatLon(lat, lon)
    {
        if (!useAnimation) {
            center = QtPositioning.coordinate(lat, lon)
        } else {
            useAnimation = false
            _centerX = center.latitude
            _centerY = center.longitude
            useAnimation = true
            _centerX = lat
            _centerY = lon
        }
    }
}

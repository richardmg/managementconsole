import QtQuick 2.1
import QtLocation 5.5
import QtPositioning 5.5
import QtQuick.Controls 1.4

Rectangle {
    property alias zoomLevel: map.zoomLevel
    property alias center: map.center
    property bool useAnimation: false

    function centerOnPark(parkId)
    {
        var park = app.model.getParkingLotModel(parkId)
        moveToLatLon(park.latitude, park.longitude)
        zoomLevel = 18
    }

    function centerOnAllParks()
    {
        map.fitViewportToMapItems()
        if (mapNotReady())
            centerOnAllParksWhenMapReadyTimer.restart()
    }

    function getOverlay(parkId)
    {
        for (var i = 0; i < map.mapItems.length; ++i)
            if (map.mapItems[i].parkModel.parkId === parkId)
                return _map.mapItems[i].overlay
        return null
    }

    Connections {
        target: app.model
        onParkModelUpdated: recreateOverlay()
    }

    Component.onCompleted: {
        recreateOverlay()
        centerOnAllParks()
    }

    function mapNotReady()
    {
        return map.zoomLevel === 0 && Math.round(map.center.longitude) === 0
    }

    Timer {
        id: centerOnAllParksWhenMapReadyTimer
        interval: 100
        onTriggered: {
            // Calling fitViewportToMapItems before the map is ready will not cause
            // it to change. And there seems to be no way to check for that condition.
            // So we need to poll...
            map.fitViewportToMapItems()
            if (mapNotReady())
                centerOnAllParksWhenMapReadyTimer.restart()
        }
    }

    Component {
        id: overlayProxyComp
        // MapCircle cannot have children. For that reason, since our overlays need to
        // be styled, we need to create a proxy overlay like this that just forwards
        // its own position to an item placed as a child of the map
        MapCircle {
            center: QtPositioning.coordinate(parkModel.latitude, parkModel.longitude)
            radius: 1

            property var parkModel
            property Item overlay

            Component.onCompleted: {
                var overlayComp = Qt.createComponent("ParkMapOverlay.qml")
                overlay = overlayComp.createObject(map, { parkModel: parkModel })
                overlay.x = Qt.binding(function() { return x + (width - overlay.width) / 2 })
                overlay.y = Qt.binding(function() { return y + (height - overlay.height) / 2 })
            }

            function destroyOverlay()
            {
                overlay.parent = null
                overlay.destroy()
            }
        }
    }

    function recreateOverlay()
    {
        var mapItems = map.mapItems
        map.clearMapItems()

        for (var i = 0; i < mapItems.length; ++i) {
            var mapItem = mapItems[i]
            mapItem.destroyOverlay()
            mapItem.destroy()
        }

        var idArray = app.model.getAllParkIds()

        for (i = 0; i < idArray.length; ++i) {
            var parkModel = app.model.getParkingLotModel(idArray[i])
            if (parkModel.isEmpty)
                continue

            var overlay = overlayProxyComp.createObject(map, { parkModel: parkModel })
            map.addMapItem(overlay)
        }
    }

    Map {
        id: map
        anchors.fill: parent
        plugin: Plugin { name: "osm" }
        zoomLevel: 16
        onErrorChanged: {
            print("Map error code:", error)
            // todo: show backup static map image
        }
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

import QtQuick 2.1
import QtLocation 5.5
import QtPositioning 5.5
import QtQuick.Controls 1.4

Rectangle {
    property alias zoomLevel: map.zoomLevel
    property alias center: map.center
    property bool useAnimation: false

    property ExpandableContainer expandableContainer
    property int descriptionCount: 0

    function centerOnPark(modelIndex)
    {
        var garage = app.model.currentModel.descriptions[modelIndex]
        moveToLatLon(garage.latitude, garage.longitude)
        zoomLevel = 15
    }

    function centerOnAllParks()
    {
//        map.fitViewportToMapItems()
        var desc = app.model.currentModel.descriptions
        if (desc.length > 0) {
            var avgLat = 0.0
            var avgLon = 0.0
            for (var i = 0; i < desc.length; ++i) {
                avgLat += Number(desc[i].latitude)
                avgLon += Number(desc[i].longitude)
            }
            avgLat /= desc.length
            avgLon /= desc.length

            // Move center a bit down to compansate for text bubble
            avgLat += 1

            moveToLatLon(avgLat, avgLon)
            zoomLevel = 6

            if (map.center.latitude !== avgLat || map.center.longitude !== avgLon)
                centerOnAllParksWhenMapReadyTimer.restart()
        }
    }

    function getOverlay(modelIndex)
    {
        for (var i = 0; i < map.mapItems.length; ++i)
            if (map.mapItems[i].parkModel.modelIndex === modelIndex)
                return _map.mapItems[i].overlay
        return null
    }

    Connections {
        target: app.model
        onDescriptionUpdated: {
            if (descriptionCount !== app.model.currentModel.descriptions.length) {
                recreateOverlay()
                centerOnAllParks()
            }
        }
    }

    Component.onCompleted: {
        recreateOverlay()
        centerOnAllParks()
    }

    function mapNotReady()
    {
        return Math.round(map.center.latitude) === 0 || Math.round(map.center.longitude) === 0
    }

    Timer {
        id: centerOnAllParksWhenMapReadyTimer
        interval: 100
        onTriggered: {
            // Calling fitViewportToMapItems before the map is ready will not cause
            // it to change. And there seems to be no way to check for that condition.
            // So we need to poll...
            centerOnAllParks()
        }
    }

    Component {
        id: overlayProxyComp
        // MapCircle cannot have children. For that reason, since our overlays need to
        // be styled, we need to create a proxy overlay like this that just forwards
        // its own position to an item placed as a child of the map
        MapCircle {
            radius: 1

            property int modelIndex: -1
            property Item overlay

            Component.onCompleted: {
                var description = app.model.currentModel.descriptions[modelIndex]
                center = QtPositioning.coordinate(description.latitude, description.longitude)
                var overlayComp = Qt.createComponent("GeoMapOverlay.qml")
                overlay = overlayComp.createObject(map, { modelIndex: modelIndex })
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

        var descriptions = app.model.currentModel.descriptions
        descriptionCount = descriptions.length

        for (var modelIndex = 0; modelIndex < descriptionCount; ++modelIndex) {
            var description = app.model.currentModel.descriptions[modelIndex]
            if (description.isEmpty || (description.latitude === null || description.longitude === null))
                continue

            var overlay = overlayProxyComp.createObject(map, { modelIndex: modelIndex })
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

    IconButton {
        id: closeButton
        baseName: expandableContainer.expanded ? "Contract" : "Expand"
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.topMargin: 12
        onClicked: expandableContainer.toggle()
    }

    IconButton {
        baseName: "MapFit"
        anchors.top: closeButton.bottom
        anchors.horizontalCenter: closeButton.horizontalCenter
        anchors.topMargin: 10
        onClicked: centerOnAllParks()
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

import QtQuick 2.1
import QtLocation 5.5
import QtPositioning 5.5
import QtQuick.Controls 1.4

Rectangle {
    property alias zoomLevel: map.zoomLevel
    property alias center: map.center
    property bool useAnimation: false

    property ExpandableContainer expandableContainer

    function centerOnPark(modelIndex)
    {
        var garage = app.model.current.getDescription(modelIndex)
        moveToLatLon(garage.Latitude, garage.Longitude)
        zoomLevel = 18
    }

    function centerOnAllParks()
    {
        map.fitViewportToMapItems()
        if (mapNotReady())
            centerOnAllParksWhenMapReadyTimer.restart()
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
        onDescriptionUpdated: recreateOverlay()
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
            center: QtPositioning.coordinate(description.Latitude, description.Longitude)
            radius: 1

            property var description
            property Item overlay

            Component.onCompleted: {
                var overlayComp = Qt.createComponent("ParkMapOverlay.qml")
                overlay = overlayComp.createObject(map, { description: description })
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

        var descriptions = app.model.current.descriptions

        for (var modelIndex = 0; modelIndex < descriptions.length; ++modelIndex) {
            var description = app.model.current.descriptions[modelIndex]
            if (description.isEmpty || (description.Latitude === null || description.Longitude === null))
                continue

            var overlay = overlayProxyComp.createObject(map, { description: description })
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
        baseName: expandableContainer.expanded ? "Contract" : "Expand"
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.topMargin: 12
        onClicked: expandableContainer.toggle()
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

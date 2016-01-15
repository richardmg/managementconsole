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

    Plugin {
        id: osmPlugin
        name: "osm"
    }

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

    Map {
        id: map
        anchors.fill: parent
        plugin: osmPlugin
        center: defaultLocation.coordinate
        zoomLevel: defaultZoomLevel

        onCenterChanged: updateOverlays()
        onZoomLevelChanged: updateOverlays()

        MouseArea {
            anchors.fill: parent
            onClicked: {
                var clickedCoord = map.toCoordinate(Qt.point(mouse.x, mouse.y));
                var overlay = overlayParkingLotComp.createObject(map, { coordinate: clickedCoord })
                _overlayList.push(overlay)
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

    function updateOverlays()
    {
        for (var i = 0; i < _overlayList.length; ++i)
            _overlayList[i].updateOverlay()
    }

    Component {
        id: overlayParkingLotComp
        Rectangle {
            width: 20
            height: 20
            color: "red"

            property var coordinate
            onCoordinateChanged: updateOverlay()

            function updateOverlay()
            {
                var pos = map.fromCoordinate(coordinate)
                x = pos.x
                y = pos.y
            }
        }
    }

    function createNativeOverlay(coord)
    {
        // map overlays from location cannot have child items, and scale upon zoom, so we don't use them.
        var circle = parkingLotMapComp.createObject(map)
        circle.center = coord
        circle.radius = 20.0
        circle.color = 'white'
        circle.border.width = 1
        map.addMapItem(circle)
    }

}

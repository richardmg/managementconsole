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

//        zoomLevel: (map.zoomLevel > minimumZoomLevel + 3) ? minimumZoomLevel + 3 : 2.5
//        center: map.center
//        gesture.enabled: false

//        MapRectangle {
//            color: "#44ff0000"
//            border.width: 1
//            border.color: "red"
//            topLeft {
//                latitude: miniMap.center.latitude + 5
//                longitude: miniMap.center.longitude - 5
//            }
//            bottomRight {
//                latitude: miniMap.center.latitude - 5
//                longitude: miniMap.center.longitude + 5
//            }
//        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                var circle = Qt.createQmlObject('import QtLocation 5.5; MapCircle {}', map)
                circle.center = map.toCoordinate(Qt.point(mouse.x, mouse.y));
                circle.radius = 5000.0
                circle.color = 'green'
                circle.border.width = 3
                map.addMapItem(circle)
                print("added pin:", circle.center.latitude, circle.center.longitude)
//                QtPositioning.coordinate()
            }
        }

        Button {
            anchors.top: parent.top
            text: "Center"
            onClicked: map.center = nuremberg.coordinate
        }


    }

}

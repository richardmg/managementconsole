import QtQuick 2.4
import QtQuick.Window 2.1
import QtLocation 5.5
import QtPositioning 5.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2

import "qrc:/components"

AbstractPage {
    id: root

    property alias parkMap: parkMap
    property int selectedIndex: -1

    SplitView {
        anchors.fill: parent
        handleDelegate: Item { width: app.spacingHor }

        ExpandableContainer {
            id: mapContainer
            expandTo: root
            Layout.fillWidth: true
            Layout.fillHeight: true
            ParkMap {
                id: parkMap
                width: parent.width
                height: parent.height
                expandableContainer: mapContainer
            }
        }

        Flickable {
            width: 340
            height: parent.height
            contentHeight: garageColumn.height

            Column {
                id: garageColumn
                width: parent.width
                height: childrenRect.height
                Repeater {
                    id: garageColumnRepeater
                    model: app.model.currentModel.descriptions.length

                    ParkingLotLog {
                        modelIndex: index
                        width: garageColumn.width
                        height: garageColumnRepeater.model <= 2 ? root.height / 2 : root.height / 2.5
                        showMapIcon: true
                        showPercentage: true
                        showExpandIcon: false
                        showDate: false
                    }
                }
            }
        }
    }
}

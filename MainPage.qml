import QtQuick 2.4
import QtQuick.Window 2.1
import QtLocation 5.5
import QtPositioning 5.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2

import "qrc:/components"

AppPage {
    id: root
    property alias parkMap: parkMap
    property int selectedParkId: -1

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

        SplitView {
            orientation: Qt.Vertical

            handleDelegate: Item { height: app.spacingVer }
            width: 320
            ParkLog {
                id: parkA
                Layout.minimumHeight: (parent.height - app.spacingVer) / 2
                Layout.maximumHeight: Layout.minimumHeight
                parkId: 0
                showMapIcon: true
                showPercentage: true
                showExpandIcon: false
                showDate: false
            }

            ParkLog {
                id: parkB
                parkId: 1
                showMapIcon: true
                showPercentage: true
                showExpandIcon: false
                showDate: false
            }
        }
    }
}

import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2

import "qrc:/components"

AppPage {
    id: root
    property int parkId: -1

    SplitView {
        anchors.fill: parent
        handleDelegate: Item { width: app.spacingHor }

        ParkDetailMap {
            border.color: app.colorDarkBg
            Layout.fillWidth: true
            parkId: root.parkId
        }

        SplitView {
            id: verticalSplit
            orientation: Qt.Vertical

            handleDelegate: Item { height: app.spacingVer }
            width: 320
            Image {
                id: webcam
                height: (parent.height - app.spacingVer) / 2
                source: "qrc:/img/parkinglot.jpg"
            }

            ExpandableContainer {
                id: parkContainer
                expandTo: root
                Layout.fillHeight: true
                ParkLog {
                    id: parkB
                    parkId: root.parkId
                    showMapIcon: false
                    showPercentage: false
                    showExpandIcon: true
                    showDate: true
                    width: parent.width
                    height: parent.height
                    expandableContainer: parkContainer
                }
            }
        }
    }

}


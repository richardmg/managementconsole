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

            ParkLog {
                id: parkB
                parkId: root.parkId
                showMapIcon: false
                showPercentage: false
                showExpandIcon: true
                showDate: true
                Layout.fillHeight: true
                Behavior on opacity { NumberAnimation{ easing.type: Easing.OutCubic } }
                onExpand: parkBExpanded.opacity = 1
            }
        }
    }

    ParkLog {
        id: parkBExpanded
        parkId: root.parkId
        showMapIcon: false
        showPercentage: false
        showExpandIcon: true
        showDate: true
        anchors.fill: parent
        opacity: 0
        visible: opacity > 0
        Behavior on opacity { NumberAnimation{ easing.type: Easing.OutCubic } }
        onExpand: opacity = 0
    }

}


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
            orientation: Qt.Vertical

            handleDelegate: Item { height: app.spacingVer }
            width: 320
            Image {
                id: webcam
                Layout.minimumHeight: (parent.height - app.spacingVer) / 2
                Layout.maximumHeight: Layout.minimumHeight
                source: "qrc:/img/parkinglot.jpg"
            }

            ParkLog {
                id: parkB
                parkId: root.parkId
                showMapIcon: false
                showPercentage: false
                showMaximizeÍcon: true
                showDate: true
            }
        }
    }

}


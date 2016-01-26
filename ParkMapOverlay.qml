import QtQuick 2.0

Item {
    width: 150
    height: 280

    property var parkModel

    Image {
        anchors.horizontalCenter: parent.horizontalCenter
        y: (parent.height / 2) - height
        source: app.mainView.selectedParkId === parkModel.parkId ?
                    "qrc:/img/ParkLocation_Focus_icon.png" :
                    "qrc:/img/ParkLocation_icon.png"

        Text {
            id: parkOverlayName
            y: 20
            anchors.horizontalCenter: parent.horizontalCenter
            font: app.fontBig.font
            text: parkModel.parkName
            color: app.colorDarkFg
        }

        ParkPercentageIndicator {
            anchors.top: parkOverlayName.bottom
            anchors.topMargin: 13
            anchors.left: parent.left
            anchors.leftMargin: 15
            anchors.right: parent.right
            anchors.rightMargin: 15
            capacity: parkModel.spaceCapacity
            occupied: parkModel.spacesOccupied.length
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: app.mainView.selectedParkId = parkModel.parkId
    }
}



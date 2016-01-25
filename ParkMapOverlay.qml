import QtQuick 2.0

Item {
    width: 150
    height: 280

    property var parkModel

    Rectangle {
        width: parent.width
        height: 100
        radius: 5
        border.width: 3
        border.color: app.mainView.selectedParkId === parkModel.parkId ? app.colorSelectedBg : app.colorDarkFg
        Text {
            id: parkOverlayName
            y: 20
            anchors.horizontalCenter: parent.horizontalCenter
            font: app.fontBig.font
            text: parkModel.parkName
            color: app.colorDarkFg
        }
        ParkingSpacePercentageIndicator {
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

    Image {
        width: 30
        height: 30
        anchors.horizontalCenter: parent.horizontalCenter
        y: (parent.height / 2) - height
        source: "qrc:/img/parkingsign.png"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: app.mainView.selectedParkId = parkModel.parkId
    }
}



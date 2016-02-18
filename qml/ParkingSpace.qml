import QtQuick 2.0

Rectangle {
    id: root
    height: 150
    property var parkingSpaceModel

    signal clicked

    color: parkingSpaceModel.status !== "Free" ? app.colorDarkBg : app.colorLightBg
    border.color: app.colorDarkBg

    property bool isFree: parkingSpaceModel.status === "Free"
    property bool isOccupied: parkingSpaceModel.status === "Occupied"
    property bool isBooked: parkingSpaceModel.status === "Booked"
    property bool isLeaving: parkingSpaceModel.status === "ToBeFree"

    Text {
        text: parkingSpaceModel.onSiteId
        anchors.horizontalCenter: parent.horizontalCenter
        font: app.fontF.font
        y: 30
    }

    Rectangle {
        height: 40
        visible: parkingSpaceModel.status !== "Free"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 5
        color: app.colorLightBg
        Text {
            text: isOccupied ? parkingSpaceModel.licensePlateNumber : isBooked ? "Booked" : isLeaving ? "Leaving" : ""
            font: app.fontA.font
            color: isOccupied ? "black" : app.colorSelectedBg
            anchors.centerIn: parent
            height: paintedHeight
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
    }

}

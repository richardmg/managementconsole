import QtQuick 2.0

Rectangle {
    id: root
    height: 150
    property var parkingSpaceModel

    signal clicked

    color: parkingSpaceModel.Status !== "Free" ? app.colorDarkBg : app.colorLightBg
    border.color: app.colorDarkBg

    property bool isFree: parkingSpaceModel.Status === "Free"
    property bool isOccupied: parkingSpaceModel.Status === "Occupied"
    property bool isReserved: parkingSpaceModel.Status === "ToBeOccupied"
    property bool isLeaving: parkingSpaceModel.Status === "ToBeFree"

    Text {
        text: parkingSpaceModel.OnSiteId
        anchors.horizontalCenter: parent.horizontalCenter
        font: app.fontF.font
        y: 30
    }

    Rectangle {
        height: 40
        visible: parkingSpaceModel.Status !== "Free"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 5
        color: app.colorLightBg
        Text {
            text: isOccupied ? parkingSpaceModel.LicensePlateNumber : isReserved ? "Reserved" : isLeaving ? "Leaving" : ""
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

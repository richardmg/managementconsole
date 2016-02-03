import QtQuick 2.0

Rectangle {
    id: root
    height: 150
    property var parkingSpaceModel

    signal clicked

    color: parkingSpaceModel.Status !== "Free" ? app.colorDarkBg : app.colorLightBg
    border.color: app.colorDarkBg

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
            text: visible ? parkingSpaceModel.LicensePlateNumber : ""
            font: app.fontA.font
            anchors.centerIn: parent
            height: paintedHeight
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
    }

}

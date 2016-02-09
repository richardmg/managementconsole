import QtQuick 2.0

Rectangle {
    color: "white"
    implicitWidth: webcam.width
    implicitHeight: webcam.height

    property ExpandableContainer expandableContainer

    Flickable {
        anchors.fill: parent
        contentHeight: webcam.height
        clip: true

        Image {
            id: webcam
            fillMode: Image.PreserveAspectFit
            width: parent.width
            source: "qrc:/img/parkinglot.jpg"
        }
    }

    IconButton {
        baseName: expandableContainer.expanded ? "Contract" : "Expand"
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.topMargin: 12
        onClicked: expandableContainer.toggle()
    }
}

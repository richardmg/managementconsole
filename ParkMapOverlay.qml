import QtQuick 2.0

Item {
    id: root
    width: 150
    height: 280

    property int modelIndex: -1
    property var description

    Component.onCompleted: description = app.model.currentModel.descriptions[modelIndex]
    Connections {
        target: app.model
        onDescriptionUpdated: {
            if (modelIndex === root.modelIndex)
                description = app.model.currentModel.descriptions[modelIndex]
        }
    }

    Image {
        anchors.horizontalCenter: parent.horizontalCenter
        y: (parent.height / 2) - height
        source: app.mainView.selectedIndex === root.modelIndex ?
                    "qrc:/img/ParkLocation_Focus_icon.png" :
                    "qrc:/img/ParkLocation_icon.png"

        Text {
            id: parkOverlayName
            y: 20
            anchors.horizontalCenter: parent.horizontalCenter
            font: app.fontD.font
            text: description.LocationName
            color: app.colorDarkFg
        }

        ParkPercentageIndicator {
            anchors.top: parkOverlayName.bottom
            anchors.topMargin: 13
            anchors.left: parent.left
            anchors.leftMargin: 15
            anchors.right: parent.right
            anchors.rightMargin: 15
            freeSpaces: description.NumberFreeParkingSpaces
            capacity: description.NumberTotalParkingSpaces
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: app.mainView.selectedIndex = root.modelIndex
    }
}



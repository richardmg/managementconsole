import QtQuick 2.0

Item {
    id: root
    width: 150
    height: 300

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
    }

    Rectangle {
        width: parent.width
        anchors.top: parent.top
        anchors.bottom: percentageIndicator.bottom
        anchors.bottomMargin: -20
        radius: 10
        border.color: app.mainView.selectedIndex === root.modelIndex ? app.colorSelectedBg : app.colorDarkBg
        border.width: app.mainView.selectedIndex === root.modelIndex ? 3 : 2
    }

    Text {
        id: parkOverlayName
        y: 20
        anchors.horizontalCenter: parent.horizontalCenter
        width: Math.min(parent.width - 10, implicitWidth)
        font: app.fontD.font
        text: description.LocationName
        elide: Text.ElideRight
        color: app.colorDarkFg
    }

    ParkPercentageIndicator {
        id: percentageIndicator
        anchors.top: parkOverlayName.bottom
        anchors.topMargin: 13
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 20
        freeSpaces: description.NumberFreeParkingSpaces
        capacity: description.NumberTotalParkingSpaces
    }

    MouseArea {
        anchors.fill: parent
        onClicked: app.mainView.selectedIndex = root.modelIndex
    }
}



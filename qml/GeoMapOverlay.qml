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
        source: app.mainViewPage.selectedIndex === root.modelIndex ?
                    "qrc:/img/ParkLocation_Focus_icon.png" :
                    "qrc:/img/ParkLocation_icon.png"
    }

    Rectangle {
        width: parent.width
        anchors.top: parent.top
        anchors.bottom: bar.bottom
        anchors.bottomMargin: -20
        radius: 10
        border.color: app.mainViewPage.selectedIndex === root.modelIndex ? app.colorSelectedBg : app.colorDarkBg
        border.width: app.mainViewPage.selectedIndex === root.modelIndex ? 3 : 2
    }

    Text {
        id: parkOverlayName
        y: 20
        anchors.horizontalCenter: parent.horizontalCenter
        width: Math.min(parent.width - 10, implicitWidth)
        font: app.fontD.font
        text: description.locationName
        elide: Text.ElideRight
        color: app.colorDarkFg
    }

    PercentageBar {
        id: bar
        anchors.top: parkOverlayName.bottom
        anchors.topMargin: 13
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 20
        anchors.rightMargin: 55
        height: 12
        freeSpaces: description.numberFreeParkingSpaces
        capacity: description.numberTotalParkingSpaces
    }

    PercentageText {
        id: percentageText
        anchors.left: bar.right
        anchors.leftMargin: 3
        anchors.top: parkOverlayName.bottom
        anchors.topMargin: 10
        font: app.fontD.font
        freeSpaces: description.numberFreeParkingSpaces
        capacity: description.numberTotalParkingSpaces
    }

    MouseArea {
        anchors.fill: parent
        onClicked: app.mainViewPage.selectedIndex = root.modelIndex
    }
}



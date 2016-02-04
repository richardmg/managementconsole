import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2

Rectangle {
    id: root
    border.color: app.colorDarkBg
    Layout.fillWidth: true

    property int modelIndex: -1
    property var parkingSpaces: []

    Connections {
        target: app.model

        onParkingSpacesUpdated: {
            if (modelIndex !== root.modelIndex)
                return
            parkingSpaces = app.model.currentModel.parkingSpaces[modelIndex]
        }

        onDescriptionUpdated: {
            if (modelIndex !== root.modelIndex)
                return
            var description = app.model.currentModel.descriptions[modelIndex]
            var newParkingSpaces = app.model.currentModel.parkingSpaces[modelIndex]
            if (description.NumberTotalParkingSpaces !== repeater.count && newParkingSpaces) {
                parkingSpaces = []
                parkingSpaces = newParkingSpaces
            }
        }
    }

    Flickable {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.topMargin: 20
        anchors.bottomMargin: 20
        contentWidth: width
        contentHeight: grid.height
        clip: true

        GridLayout {
            id: grid
            width: parent.width
            height: childrenRect.height
            columnSpacing: 10
            rowSpacing: 20
            columns: 4

            Repeater {
                id: repeater
                model: root.parkingSpaces.length
                ParkingSpace {
                    Layout.fillWidth: true
                    parkingSpaceModel: root.parkingSpaces[index]
                    onClicked: parkingSpaceDetails.showModel(parkingSpaceModel)
                }
            }
        }
    }

    ParkingSpaceDetails {
        id: parkingSpaceDetails
        expandTo: root
        anchors.fill: parent
    }
}

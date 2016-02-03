import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2

Rectangle {
    id: root
    border.color: app.colorDarkBg
    Layout.fillWidth: true

    property int modelIndex: -1

    property var parkingSpaces: app.model.current.parkingSpaces[modelIndex]

    Connections {
        target: app.model
        onCurrentChanged: {
            parkingSpaces = []
            parkingSpaces = app.model.current.parkingSpaces[modelIndex]
        }

        onParkingSpacesUpdated: {
            if (modelIndex !== root.modelIndex)
                return
            parkingSpaces = app.model.current.parkingSpaces[modelIndex]
        }

        onDescriptionUpdated: {
            if (modelIndex !== root.modelIndex)
                return
            var description = app.model.current.descriptions[modelIndex]
            if (description.NumberTotalParkingSpaces !== repeater.count) {
                parkingSpaces = []
                parkingSpaces = app.model.current.parkingSpaces[modelIndex]
            }
        }
    }

    Flickable {
        anchors.fill: parent
        anchors.leftMargin: 20
        anchors.rightMargin: 20
        anchors.topMargin: 40
        anchors.bottomMargin: 40
        contentWidth: width
        contentHeight: grid.height
        clip: true

        GridLayout {
            id: grid
            width: parent.width
            height: childrenRect.height
            columnSpacing: 20
            rowSpacing: 40
            columns: 4

            Repeater {
                id: repeater
                model: parkingSpaces.length
                ParkingSpace {
                    Layout.fillWidth: true
                    parkingSpaceModel: parkingSpaces[index]
                }
            }
        }
    }

}

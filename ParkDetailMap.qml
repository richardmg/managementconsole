import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2

Rectangle {
    id: root
    border.color: app.colorDarkBg
    Layout.fillWidth: true

    property int modelIndex: -1

    property var parkingSpaces: app.model.current.descriptions[modelIndex]

    Connections {
        target: app.model
        onParkingSpacesUpdated: {
            if (modelIndex !== root.modelIndex)
                return

            var newParkingSpaces = app.model.current.parkingSpaces[modelIndex]
            if (parkingSpaces.length !== newParkingSpaces.length)
                parkingSpaces = []
            parkingSpaces = newParkingSpaces
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
                model: parkingSpaces.length
                Rectangle {
                    Layout.fillWidth: true
                    height: 150
                    property bool occupied: parkingSpaces[index].Status !== "Free"
                    color: occupied ? app.colorDarkBg : app.colorLightBg
                    border.color: app.colorDarkBg
                }
            }
        }
    }

    function arrayContainsNumber(array, number)
    {
        for (var i = 0; i < array.length; ++i) {
            if (array[i] === number)
                return true
        }
        return false
    }

}

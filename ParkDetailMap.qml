import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2

Rectangle {
    id: root
    border.color: app.colorDarkBg
    Layout.fillWidth: true

    property int modelIndex: -1

    property var description
    Component.onCompleted: description = app.model.current.descriptions[modelIndex]

    Connections {
        target: app.model
        onDescriptionUpdated: {
            if (modelIndex !== root.modelIndex)
                return
            description = app.model.current.descriptions[modelIndex]
        }
    }

    GridLayout {
        anchors.fill: parent
        anchors.leftMargin: 20
        anchors.rightMargin: 20
        anchors.topMargin: 50
        anchors.bottomMargin: 50
        columnSpacing: 20
        rowSpacing: 50
        columns: 4
        rows: 2

        Repeater {
            model: description.spaceCapacity
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                property bool occupied: false//arrayContainsNumber(description.spacesOccupied, index)
                color: occupied ? app.colorDarkBg : app.colorLightBg
                border.color: app.colorDarkBg
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

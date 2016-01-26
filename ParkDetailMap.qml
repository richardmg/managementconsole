import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2

Rectangle {
    id: root
    border.color: app.colorDarkBg
    Layout.fillWidth: true

    property int parkId: -1

    property var _model: app.model.getParkModel(parkId)

    Connections {
        target: app.model
        onParkModelUpdated: {
            if (parkId !== root.parkId)
                return
            _model = app.model.getParkModel(parkId)
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
            model: 8
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                property bool occupied: isOccupied(index)
                color: occupied ? app.colorDarkBg : app.colorLightBg
                border.color: app.colorDarkBg
            }
        }

    }

    function isOccupied(index)
    {
        for (var i = 0; i < _model.spacesOccupied.length; ++i) {
            if (_model.spacesOccupied[i] === index)
                return true
        }
        return false
    }
}

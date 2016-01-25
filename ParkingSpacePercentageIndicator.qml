import QtQuick 2.0

Item {
    width: 120
    height: percentageText.height

    property alias capacity: percentageText.capacity
    property alias occupied: percentageText.occupied

    Row {
        spacing: 2
        anchors.fill: parent
        Repeater {
            model: 8
            Rectangle {
                width: 7
                height: parent.height
                color: index < occupied ? border.color : "transparent"
                border.color: app.colorGreenBg
            }
        }
    }

    PercentageText {
        id: percentageText
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
    }
}


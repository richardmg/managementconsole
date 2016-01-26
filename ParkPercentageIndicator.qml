import QtQuick 2.0

Item {
    height: percentageText.height

    property alias capacity: percentageText.capacity
    property alias occupied: percentageText.occupied

    Row {
        id: ticks
        spacing: 2
        anchors.fill: parent
        anchors.rightMargin: 40
        Repeater {
            model: capacity
            Rectangle {
                width: (ticks.width - (ticks.spacing * capacity)) / capacity
                height: parent.height
                color: index < occupied ? border.color : border.width === 0 ? app.colorLightFg : "transparent"
                border.color: app.colorGreenBg
                border.width: width > 3 ? 1 : 0
            }
        }
    }

    PercentageText {
        id: percentageText
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
    }
}


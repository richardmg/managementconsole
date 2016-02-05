import QtQuick 2.0

Item {
    height: percentageText.height

    property alias freeSpaces: percentageText.freeSpaces
    property alias capacity: percentageText.capacity

    Row {
        id: ticks
        spacing: 2
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: 45
        anchors.verticalCenter: parent.verticalCenter
        property real tickWidth: (width - (spacing * capacity)) / capacity
        height: tickWidth * 2

        Repeater {
            model: capacity
            Rectangle {
                width: ticks.tickWidth
                height: ticks.height
                color: index < (capacity - freeSpaces) ? border.color : border.width === 0 ? app.colorLightFg : "transparent"
                border.color: app.colorGreenBg
                border.width: width > 3 ? 1 : 0
            }
        }
    }

    PercentageText {
        id: percentageText
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        font: app.fontD.font
    }
}


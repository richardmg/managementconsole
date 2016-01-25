import QtQuick 2.0

Item {
    width: 120
    height: 20

    property alias capacity: percentageText.capacity
    property alias occupied: percentageText.occupied

    Rectangle {
        width: 80
        height: 20
        color: "green"
    }

    PercentageText {
        id: percentageText
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
    }
}


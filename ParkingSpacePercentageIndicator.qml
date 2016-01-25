import QtQuick 2.0

Item {
    width: 120
    height: 20

    property int capacity: 10
    property int occupied: 0

    Rectangle {
        width: 80
        height: 20
        color: "green"
    }

    Text {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        font: app.fontBig.font
        color: app.colorDarkFg
        text: {
            if (occupied >= capacity)
                return "FULL"
            else
                return  ((occupied / capacity).toFixed(1) * 100) + "%"
        }
    }
}


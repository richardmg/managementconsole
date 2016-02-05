import QtQuick 2.0

Item {
    property int freeSpaces: 8
    property int capacity: 8

    Rectangle {
        id: bar
        anchors.left: parent.left
        anchors.right: parent.right
        border.color: colorDarkBg
        height: 14

        Rectangle {
            color: app.colorGreenBg
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 2
            x: 2
            width: ((1 - (freeSpaces / capacity)) * parent.width) - (x * 2)
        }
    }
}


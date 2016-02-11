import QtQuick 2.0

Item {
    id: root
    property int freeSpaces: 8
    property int capacity: 8

    Row {
        anchors.fill: parent
        spacing: 2
        Repeater {
            model: capacity
            Rectangle {
                width: 7
                height: root.height
                color: index < (capacity - freeSpaces) ? app.colorGreenBg : "white"
                border.color: app.colorGreenBg
            }
        }
    }
}


import QtQuick 2.0

Rectangle {
    border.width: 2
    border.color: "black"

    property alias model: listView.model

    Item {
        anchors.fill: parent
        anchors.margins: 10

        TextEdit {
            id: headerEdit
            text: "Park A"
            font.pixelSize: 24
        }

        Rectangle {
            id: headerLine
            anchors.top: headerEdit.bottom
            anchors.topMargin: 10
            width: parent.width
            height: 3
            color: "darkgray"//Qt.rgba(1.0, 1.0, 1.0, 1.0)
        }

        ListView {
            id: listView
            anchors.top: headerLine.bottom
            anchors.bottom: parent.bottom
            width: parent.width
            clip: true

            delegate: Item {
                width: parent.width
                height: 60//childrenRect.height

                Rectangle {
                    id: underline
                    width: parent.width
                    height: 2
                    anchors.bottom: parent.bottom
                    color: "lightgray"
                }

                TextEdit {
                    id: logMessageEdit
                    text: name
                    font.pixelSize: 18
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }
}

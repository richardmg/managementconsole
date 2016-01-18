import QtQuick 2.0

Rectangle {
    border.width: 2
    border.color: appDarkLine

    property alias model: listView.model

    Item {
        anchors.fill: parent
        anchors.margins: 10

        TextEdit {
            id: headerEdit
            text: "Park A"
            font: appBigFont.font
        }

        Rectangle {
            id: headerLine
            anchors.top: headerEdit.bottom
            anchors.topMargin: 10
            width: parent.width
            height: 3
            color: appDarkLine
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
                    color: appLightLine
                }

                TextEdit {
                    id: logMessageEdit
                    text: name
                    font: appNormalFont.font
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }
}

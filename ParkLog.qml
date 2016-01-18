import QtQuick 2.0
import QtQuick.Layouts 1.2

Rectangle {
    border.width: 2
    border.color: appDarkLine

    property string name
    property alias model: listView.model

    Item {
        anchors.fill: parent
        anchors.margins: 5

        TextEdit {
            id: headerEdit
            text: name
            font: appBigFont.font
            readOnly: true
            x: 10
            y: 6
        }

        Rectangle {
            id: headerLine
            anchors.top: headerEdit.bottom
            anchors.topMargin: 10
            width: parent.width
            height: 2
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
                height: logMessage.paintedHeight + 20

                RowLayout {
                    id: modelContent
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 10
                    x: spacing
                    width: parent.width - (x * 2)
                    height: parent.height

                    Item {
                        id: logIcon
                        width: 40
                        height: 20
                        Rectangle {
                            width: logMessage.paintedHeight
                            height: width
                            radius: width
                            anchors.centerIn: parent
                            color: listView.model[index].icon === "normal" ? "green" : "red"
                        }
                    }

                    Rectangle {
                        id: separator1
                        width: 2
                        height: logMessage.paintedHeight
                        color: appDarkLine
                    }

                    TextEdit {
                        id: logMessage
                        text: listView.model[index].message
                        font: appNormalFont.font
                        readOnly: true
                        Layout.fillWidth: true
                    }

                    Rectangle {
                        id: separator2
                        width: 2
                        height: logMessage.paintedHeight
                        color: appDarkLine
                    }

                    TextEdit {
                        id: logTime
                        text: listView.model[index].time
                        font: appNormalFont.font
                        readOnly: true
                    }
                }

                Rectangle {
                    id: underline
                    width: parent.width
                    height: 1
                    anchors.bottom: parent.bottom
                    color: appLightLine
                }

            }
        }
    }
}

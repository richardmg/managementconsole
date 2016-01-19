import QtQuick 2.0
import QtQuick.Layouts 1.2

Rectangle {
    id: parkLog
    border.width: 2
    border.color: appDarkLine

    property var model

    Item {
        anchors.fill: parent
        anchors.margins: 5

        RowLayout {
            id: listHeader
            spacing: 10
            x: spacing
            width: parent.width - (x * 2)
            height: headerParkName.paintedHeight + 6

            TextEdit {
                id: headerParkName
                text: parkLog.model.parkName
                font: appBigFont.font
                Layout.fillWidth: true
                readOnly: true
                x: 10
                y: 6
            }

            TextEdit {
                id: headerFreeSpaces
                text: "Free spaces: " + parkLog.model.freeSpaces
                font: appSmallFont.font
                readOnly: true
                x: 10
                y: 6
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    var prev = gParkMap.getOverlay(gSelectedParkId)
                    if (prev)
                        prev.highlight(false)

                    gParkMap.getOverlay(model.parkId).highlight(true)
                    gParkMap.centerOnAllParks()
                    gSelectedParkId = model.parkId
                }
            }
        }

        Rectangle {
            id: headerLine
            anchors.top: listHeader.bottom
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
            model: parkLog.model.log

            delegate: Item {
                width: parent.width
                height: logMessage.paintedHeight + 20
                property var log: parkLog.model.log[index]

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
                            color: log.icon === "normal" ? "green" : "red"
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
                        text: log.message
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
                        text: log.time
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

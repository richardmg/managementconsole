import QtQuick 2.0
import QtQuick.Layouts 1.2

import "model.js" as Model

Rectangle {
    id: parkLog
    border.width: 2
    border.color: appDarkLine

    property int parkId: -1

    property var _model: Model.getParkingLotModel(parkId)

    Connections {
        target: root
        onParkModelUpdated: {
            if (parkId !== parkLog.parkId)
                return
            _model = Model.getParkingLotModel(parkId)
        }
    }

    Item {
        anchors.fill: parent
        anchors.margins: 5

        Rectangle {
            id: listHeader
            width: parent.width - (x * 2)
            height: headerParkName.paintedHeight + 20
            color: gSelectedParkId === parkId ? appSelectedBg : "white"

            RowLayout {
                anchors.fill: parent
                spacing: 10
                x: spacing

                TextEdit {
                    id: headerParkName
                    text: parkLog._model.parkName
                    font: appBigFont.font
                    Layout.fillWidth: true
                    readOnly: true
                    x: 10
                    y: 6
                }

                TextEdit {
                    id: headerFreeSpaces
                    text: "Free spaces: " + parkLog._model.freeSpaces
                    font: appSmallFont.font
                    readOnly: true
                    x: 10
                    y: 6
                }
            }

            Rectangle {
                id: headerLine
                anchors.bottom: parent.bottom
                width: parent.width
                height: 2
                color: appDarkLine
            }

            MouseArea {
                anchors.fill: parent
                onClicked: gSelectPark(parkLog._model.parkId)
            }
        }

        ListView {
            id: listView
            anchors.top: listHeader.bottom
            anchors.bottom: parent.bottom
            width: parent.width
            clip: true
            model: parkLog._model.log

            delegate: Item {
                width: parent.width
                height: logMessage.paintedHeight + 20
                property var log: parkLog._model.log[index]

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

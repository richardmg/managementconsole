import QtQuick 2.0
import QtQuick.Layouts 1.2

Item {
    id: parkLog

    property int parkId: -1
    property bool showMapIcon: true
    property bool showPercentage: true
    property bool showExpandIcon: false
    property bool showDate: false

    property var _model: app.model.getParkModel(parkId)
    property bool _pendingModelUpdate: false

    Connections {
        target: app.model
        onParkModelUpdated: {
            if (parkId !== parkLog.parkId)
                return
            if (listView.moving)
                _pendingModelUpdate = true
            else
                updateModel()
        }
    }

    function updateModel()
    {
        _pendingModelUpdate = false
        _model = app.model.getParkModel(parkId)
    }

    Item {
        anchors.fill: parent
        anchors.margins: 5

        Item {
            id: listHeader
            width: parent.width - (x * 2)
            height: headerParkName.paintedHeight + 40

            RowLayout {
                anchors.fill: parent
                spacing: 10
                x: spacing

                TextEdit {
                    id: headerParkName
                    text: parkLog._model.parkName
                    font: app.fontBig.font
                    Layout.fillWidth: true
                    readOnly: true
                    color: app.colorDarkFg
                    x: 10
                    y: 6
                }

//                Text {
//                    font: app.fontBig.font
//                    color: app.colorDarkFg
//                    text: "|"
//                }

                PercentageText {
                    id: headerFreeSpaces
                    visible: showPercentage
                    occupied: parkLog._model.spacesOccupied.length
                    capacity: parkLog._model.spaceCapacity
                    x: 10
                    y: 6
                }

                Image {
                    visible: showMapIcon
                    source: app.mainView.selectedParkId === parkId ?
                                "qrc:/img/Locate_Focus_btn.png" :
                                "qrc:/img/Locate_btn.png"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            app.mainView.selectedParkId = parkLog._model.parkId
                            app.mainView.parkMap.centerOnAllParks()
                        }
                    }
                }

                Image {
                    visible: showExpandIcon
                    source: true ?
                                "qrc:/img/Expand_btn.png" :
                                "qrc:/img/Contract_btn.png"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            app.mainView.selectedParkId = parkLog._model.parkId
                            app.mainView.parkMap.centerOnAllParks()
                        }
                    }
                }
            }

            Rectangle {
                id: headerLine
                anchors.bottom: parent.bottom
                width: parent.width
                height: 1
                color: app.colorDarkFg
            }

        }

        ListView {
            id: listView
            anchors.top: listHeader.bottom
            anchors.bottom: parent.bottom
            width: parent.width
            clip: true
            model: parkLog._model.log

            onMovingChanged: {
                if (!moving && _pendingModelUpdate)
                    updateModel()
            }

            delegate: Item {
                width: parent.width
                height: logMessage.paintedHeight + 20
                property var log: parkLog._model.log[parkLog._model.log.length - index - 1]

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
                        Image {
                            anchors.centerIn: parent
                            source: log.type === "alert" ? "qrc:/img/Alarm_icon.png" : "qrc:/img/Vehicle_icon.png"
                        }
                    }

                    TextEdit {
                        id: logMessage
                        text: log.message
                        font: app.fontNormal.font
                        readOnly: true
                        Layout.fillWidth: true
                        color: app.colorDarkFg
                    }

                    TextEdit {
                        id: logTime
                        text: log.time
                        font: app.fontNormal.font
                        readOnly: true
                        color: app.colorDarkFg
                    }
                }

                Rectangle {
                    id: underline
                    width: parent.width
                    height: 1
                    anchors.bottom: parent.bottom
                    color: app.colorLightFg
                }

            }
        }
    }
}

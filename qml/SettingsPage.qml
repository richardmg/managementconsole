import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2
import QtWebSockets 1.0

import "qrc:/components/qml"

TopLevelPage {
    id: root

    //=====================================
    // Sync data source with model
    //=====================================

    ExclusiveGroup {
        id: dataSourceGroup
        onCurrentChanged: {
            var prevModel = app.model.currentModel
            if (current === remoteSource)
                app.model.currentModel = app.model.xmlHttpRequestModel
            else if (current === offlineSource)
                app.model.currentModel = app.model.fakeModel

            if (prevModel !== app.model.currentModel) {
                app.model.currentModel.reload()
                app.mainViewPage.parkMap.centerOnAllParks()
            }
        }
    }

    Connections {
        target: app.model
        onCurrentModelChanged: {
            if (app.model.currentModel === app.model.xmlHttpRequestModel)
                dataSourceGroup.current = remoteSource
            else if (app.model.currentModel === app.model.fakeModel)
                dataSourceGroup.current = offlineSource
        }
    }

    //=====================================

    Connections {
        target: app.keyboard
        onAboutToOpen: {
            if (!root.visible)
                return
            flickable.contentY = flickable.mapFromItem(app.activeFocusItem, 0, 0).y
        }
        onAboutToClose: {
            if (!root.visible)
                return
            flickable.contentY = 0
            app.activeFocusItem.focus = false
        }
    }

    Flickable {
        id: flickable
        anchors.fill: parent
        contentHeight: settingsGrid.height + (app.keyboard ? app.keyboard.height : 0)
        clip: true

        GridLayout {
            id: settingsGrid
            columns: 1

            GridLayout {
                RadioButton {
                    id: remoteSource
                    text: "Remote server:"
                    checked: app.model.currentModel === app.model.xmlHttpRequestModel
                    exclusiveGroup: dataSourceGroup
                }

                TextField {
                    id: remoteConnectionUrl
                    Layout.preferredWidth: 400
                    text: app.model.xmlHttpRequestModel.baseUrl
                    onAccepted: {
                        app.model.currentModel = app.model.xmlHttpRequestModel
                        app.model.xmlHttpRequestModel.baseUrl = text
                    }
                }

                Rectangle {
                    id: remoteConnectionStatusIndicator
                    width: 10
                    height: width
                    radius: width
                    color: "gray"

                    Connections {
                        target: app.model.xmlHttpRequestModel
                        onStatusChanged: {
                            var status = app.model.xmlHttpRequestModel.status
                            if (status === WebSocket.Connecting)
                                remoteConnectionStatusIndicator.color = "yellow"
                            else if (status === WebSocket.Open)
                                remoteConnectionStatusIndicator.color = app.colorGreenBg
                            else if (status === WebSocket.Closed)
                                remoteConnectionStatusIndicator.color = "gray"
                            else if (status === WebSocket.Error)
                                remoteConnectionStatusIndicator.color = "red"
                        }
                    }
                }
            }

            RadioButton {
                id: offlineSource
                text: "Use offline data"
                checked: app.model.currentModel === app.model.fakeModel
                exclusiveGroup: dataSourceGroup
            }

            CheckBox {
                text: "Use offline map"
                onCheckedChanged: {
                }
            }

            Rectangle { width: 10; height: 10; color:"transparent"; }

            GridLayout {
                columns: 2

                Text {
                    text: "Location name filter:"
                }

                TextField {
                    id: locationNameFilter
                    Layout.preferredWidth: 400
                    text: app.model.locationNameFilter
                    placeholderText: "Regular expression"
                    onAccepted: {
                        app.model.locationNameFilter = text
                        app.model.currentModel.reload()
                        focus = false
                    }
                }

                Text {
                    text: "Server update interval:"
                }

                TextField {
                    id: pollInterval
                    Layout.preferredWidth: 400
                    text: app.model.pollIntervalMs / 1000
                    placeholderText: "seconds"
                    onAccepted: {
                        var number = Number(text)
                        if (number < 10)
                            number = 10
                        text = number
                        app.model.pollIntervalMs = Number(number * 1000)
                        focus = false
                    }
                }
            }

            Rectangle { width: 10; height: 20; color:"transparent"; }

            Row {
                spacing: 10
                Button {
                    text: "Request update"
                    onClicked: {
                        app.model.currentModel.update()
                    }
                }
                Button {
                    text: "Reset configuration"
                    onClicked: {
                        app.model.xmlHttpRequestModel.baseUrl = app.model.xmlHttpRequestModel.originalBaseUrl
                        locationNameFilter.text = app.model.defaultLocationNameFilter
                        app.model.locationNameFilter = locationNameFilter.text
                        app.model.pollIntervalMs = app.model.defaultPollIntervalMs
                        pollInterval.text = app.model.pollIntervalMs / 1000
                        app.model.currentModel.reload()
                    }
                }
            }
        }

    }


}


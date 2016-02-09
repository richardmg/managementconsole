import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2
import QtWebSockets 1.0

import "qrc:/components/qml"

TopLevelPage {

    //=====================================
    // Sync data source with model
    //=====================================

    ExclusiveGroup {
        id: dataSourceGroup
        onCurrentChanged: {
            if (current === remoteSource)
                app.model.currentModel = app.model.xmlHttpRequestModel
            else if (current === offlineSource)
                app.model.currentModel = app.model.fakeModel
            app.mainView.parkMap.centerOnAllParks()
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

        Rectangle { width: 10; height: 10; color:"transparent"; }

        CheckBox {
            text: "Use offline map"
            onCheckedChanged: {
            }
        }

        Rectangle { width: 10; height: 10; color:"transparent"; }

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
                }
            }
        }
    }


}


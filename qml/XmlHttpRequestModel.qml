import QtQuick 2.0
import QtWebSockets 1.0

Item {
    id: root

    readonly property string originalBaseUrl: "http://iotparking-prod.azurewebsites.net/api/tdxremote/"
    property string baseUrl: originalBaseUrl
    property int status: WebSocket.Closed

    // Note: these three arrays need to be in sync with regards
    // to index, since we don't use lookup on garage id.
    property var descriptions: []
    property var parkingSpaces: []
    property var logs: []
    property var updateStamps: []

    onBaseUrlChanged: update()

    function update()
    {
        load("garage", function(array) {
            descriptions = array

            if (parkingSpaces.length !== descriptions.length)
                parkingSpaces = new Array(descriptions.length)

            for (var modelIndex = 0; modelIndex < descriptions.length; ++modelIndex) {
                updateStamps[modelIndex] = new Date()
                updateParkingspaces(modelIndex)
                if (app.model.currentModel === root) {
                    app.model.updateTimeUpdated(modelIndex)
                    app.model.descriptionUpdated(modelIndex)
                }
            }
        })
    }

    function updateParkingspaces(modelIndex)
    {
        var id = descriptions[modelIndex].id
        load("parkingspace?garageId=" + id, function(array) {
            parkingSpaces[modelIndex] = array
            if (app.model.currentModel === root)
                app.model.parkingSpacesUpdated(modelIndex)
        })
    }

    function dump(str, obj)
    {
        print(str, JSON.stringify(obj, 0, "   "))
    }

    function load(action, callback)
    {
        status = WebSocket.Connecting
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function() {
            if (xmlhttp.readyState === XMLHttpRequest.DONE) {
                if (xmlhttp.status == 200) {
                    status = WebSocket.Open
                    callback(JSON.parse(xmlhttp.responseText))
                } else {
                    print("WARNING! MODEL: could not get data from server (" + action + "):", xmlhttp.statusText)
                    status = WebSocket.Error
                }
            }
        }

        xmlhttp.open("GET", baseUrl + "/" + action, true);
        xmlhttp.send();
    }


    Timer {
        running: app.model.currentModel === root
        interval: app.model.pollIntervalMs
        repeat: true
        onTriggered: {
            update()
//            app.model.descriptionUpdated(modelIndex)
//            app.model.logUpdated(modelIndex, removeCount, appendCount)
        }
    }

}

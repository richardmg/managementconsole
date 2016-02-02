import QtQuick 2.0
import QtWebSockets 1.0

Item {
    id: root

    readonly property string originalBaseUrl: "http://cloudparkingdemo.azurewebsites.net/api/tdxremote"
    property string baseUrl: originalBaseUrl
    property int status: WebSocket.Closed

    // Note: these three arrays need to be in sync with regards
    // to index, since we don't use lookup on garage id.
    property var descriptions: new Array
    property var parkingSpaces: new Array
    property var logs: new Array

    onBaseUrlChanged: update()

    function update()
    {
        load("garage", function(array) {
            descriptions = array
            for (var modelIndex = 0; modelIndex < descriptions.length; ++modelIndex)
                app.model.descriptionUpdated(modelIndex)
        })

        load("parkingspace", function(array) {
            parkingSpaces = array
            for (var modelIndex = 0; modelIndex < parkingSpaces.length; ++modelIndex)
                app.model.parkingSpacesUpdated(modelIndex)
        })
    }

    function load(action, callback)
    {
        status = WebSocket.Connecting
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function() {
            if (xmlhttp.readyState === XMLHttpRequest.DONE) {
                if (xmlhttp.status == 200) {
                    print("MODEL: got data from server (" + action + ")")
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
        running: app.model.current === root
        interval: app.model.pollIntervalMs
        repeat: true
        onTriggered: {
            update()
//            app.model.descriptionUpdated(modelIndex)
//            app.model.logUpdated(modelIndex, removeCount, appendCount)
        }
    }

}

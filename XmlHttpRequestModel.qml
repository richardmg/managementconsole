import QtQuick 2.0
import QtWebSockets 1.0

Item {
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
        load("garage", function(garageArray) {
            descriptions = garageArray
            for (var modelIndex = 0; modelIndex < descriptions.length; ++modelIndex)
                app.model.descriptionUpdated(modelIndex)
        })
    }

    function load(action, callback)
    {
        status = WebSocket.Connecting
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function() {
            if (xmlhttp.readyState === XMLHttpRequest.DONE) {
                if (xmlhttp.status == 200) {
//                    print(JSON.stringify(JSON.parse(xmlhttp.responseText), 0, "   "))
                    status = WebSocket.Open
                    callback(JSON.parse(xmlhttp.responseText))
                } else {
                    status = WebSocket.Error
                    print("WARNING! could not get data from server (" + action + "):", xmlhttp.statusText)
                }
            }
        }

        xmlhttp.open("GET", baseUrl + "/" + action, true);
        xmlhttp.send();
    }

    function dumpObject(obj)
    {
        print(JSON.stringify(obj, 0, "   "))
    }

}

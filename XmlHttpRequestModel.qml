import QtQuick 2.0
import QtWebSockets 1.0

Item {
    readonly property string originalBaseUrl: "http://cloudparkingdemo.azurewebsites.net/api/tdxremote"
    property string baseUrl: originalBaseUrl
    property int status: WebSocket.Closed

    property var ids: new Array
    property var descriptions: new Array
    property var parkingSpaces: new Array
    property var logs: new Array

    onBaseUrlChanged: update()

    function update()
    {
         load("garage", function(garageArray) {
            var prevIds = ids
            ids = new Array
            for (var i = 0; i < garageArray.length; ++i)
                ids.push(garageArray[i].Id);

            if (ids.length !== prevIds.length)
                app.model.idsUpdated()
            // todo: should theoretiacally compare
            // ids as well to catch any changes, but
            // skipping that for now.

            for (i = 0; i < ids.length; ++i)
                app.model.descriptionUpdated(ids[i])
        })
    }

    function getIds()
    {
        return ids
    }

    function getDescription(garageId)
    {
        for (var i = 0; i < descriptions.length; ++i)
            if (descriptions[i].Id === garageId)
                return descriptions[i]
        return app.model.createEmptyDescription()
    }

    function getParkingSpaces(garageId)
    {
        return parkingSpaces
    }

    function getLog(garageId)
    {
        return logs
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

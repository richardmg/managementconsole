import QtQuick 2.0
import QtWebSockets 1.0

Item {
    id: root

    readonly property string originalBaseUrl: "http://cloudparkingdemo.azurewebsites.net/api/tdxremote"
    property string baseUrl: originalBaseUrl
    property int status: WebSocket.Closed

    // Note: these three arrays need to be in sync with regards
    // to index, since we don't use lookup on garage id.
    property var descriptions: []
    property var parkingSpaces: []
    property var logs: []

    onBaseUrlChanged: update()

    function update()
    {
        load("garage", function(array) {
            descriptions = array

            if (parkingSpaces.length !== descriptions.length)
                parkingSpaces = new Array(descriptions.length)

            for (var modelIndex = 0; modelIndex < descriptions.length; ++modelIndex) {
                app.model.descriptionUpdated(modelIndex)
                updateParkingspaces(modelIndex)
            }
        })

//        load("parkingspace", function(array) {
//            dump("got parking spaces:", array)
//            parkingSpaces = array
//            for (var modelIndex = 0; modelIndex < parkingSpaces.length; ++modelIndex)
//                app.model.parkingSpacesUpdated(modelIndex)
//        })

//        load("garage?{1}", function(array) {
//            dump("got garage 1:", array)
//        })

//        load("garage?garageId=0&parkingSpaceOnSite=0&numberOfEntries=10", function(array) {
//            print("got log 0:", JSON.stringify(array, 0, "   "))
//        })

//        load("garage?garageId=1&parkingSpaceOnSite=1&numberOfEntries=10", function(array) {
//            print("got log 1:", JSON.stringify(array, 0, "   "))
//        })
    }

    function updateParkingspaces(modelIndex)
    {
        var id = descriptions[modelIndex].Id
        load("parkingspace?garageId=" + id, function(array) {
            parkingSpaces[modelIndex] = array
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

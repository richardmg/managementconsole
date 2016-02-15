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

    function reload()
    {
        parkingSpaces = []
        logs = []
        updateStamps = []
        descriptions = []

        update()
    }

    function update()
    {
        if (app.model.currentModel !== root)
            return
        updateGarages()
    }

    function updateGarages()
    {
        load("garage", function(array) {
            var locationNameRegExp = new RegExp(app.model.locationNameFilter);
            var filteredDescriptions = []
            for (var i = 0; i < array.length; ++i) {
                if (locationNameRegExp.test(array[i].locationName))
                    filteredDescriptions.push(array[i])
            }

            descriptions = filteredDescriptions

            if (parkingSpaces.length !== descriptions.length)
                parkingSpaces = new Array(descriptions.length)

            for (var modelIndex = 0; modelIndex < descriptions.length; ++modelIndex) {
                updateStamps[modelIndex] = new Date()
                updateParkingspaces(modelIndex)
                updateGarageStatistics(modelIndex)
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

    function updateGarageStatistics(modelIndex)
    {
        var id = descriptions[modelIndex].id

        if (logs.length === 0) {
            // Reload the whole log
            var maxLength = app.model.maxLogLength
            load("statistics/garage?garageId=" + id + "&numberOfEntries=" + maxLength, function(array) {
                logs[modelIndex] = array
                if (app.model.currentModel === root)
                    app.model.logUpdated(modelIndex, 0, 0)
            })
            return
        }

        // Incremental update
        var log = logs[modelIndex]
        var lastEntry = log[log.length - 1]
        var lastEntryDate = lastEntry.modificationDate
        var now = new Date().toISOString()

        load("statistics/garage?garageId=" + id + "&start=" + lastEntryDate + "&end=" + now, function(array) {
            // Remove entries with date equal to lastEntryDate
            // Append all the new ones (which should include the ones removed as well)
            var removeDuplicates = 0
            for (var i = log.length - 1; i <= 0; --i) {
                if (log[i].modificationDate === lastEntryDate)
                    ++removeDuplicates
            }
            if (removeDuplicates > 0)
                log.splice(log.length - removeDuplicates, removeDuplicates)

            var appendCount = array.length
            for (i = 0; i < appendCount; ++i)
                log.push(array[i])

            var removeCount = 0
            var overFlow = log.length - app.model.maxLogLength
            if (overFlow > 0) {
                // Trim log length:
                removeCount = overFlow
                log.splice(0, removeCount)
            }

            print("removed:", removeCount, "appended:", appendCount)

            if (app.model.currentModel === root)
                app.model.logUpdated(modelIndex, removeCount, appendCount)
        })
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
        }
    }

}

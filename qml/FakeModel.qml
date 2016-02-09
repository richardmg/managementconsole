import QtQuick 2.4

Item {
    id: root

    // Note: these three arrays need to be in sync with regards
    // to index, since we don't use lookup on garage id.
    property var descriptions: []
    property var parkingSpaces: []
    property var logs: []
    property var updateStamps: []

    Component.onCompleted: {
        createModels()
        fakeLogHistory(0)
        fakeLogHistory(1)
        update()
    }

    function update()
    {
        for (var modelIndex = 0; modelIndex < descriptions.length; ++modelIndex) {
            app.model.updateTimeUpdated(modelIndex)
            app.model.descriptionUpdated(modelIndex)
            app.model.parkingSpacesUpdated(modelIndex)
            app.model.logUpdated(modelIndex, 0, 0)
        }
    }

    function fakeLogHistory(modelIndex)
    {
        for (var i = 0; i < 10; ++i)
            addLogEntry(modelIndex)
    }

    function createModels()
    {
        var newDescriptions = []
        var newParkingSpaces = []
        var newLogs = []
        var newUpdateStamps = []
        var parkingSpaceCount = 8

        for (var i = 0; i < 2; ++i) {
            // Common for all garages
            newDescriptions.push({
                 Id: i,
                 NumberFreeParkingSpaces: parkingSpaceCount,
                 NumberTotalParkingSpaces: parkingSpaceCount,
             })
            newParkingSpaces.push([])
            newLogs.push([])
            newUpdateStamps.push(new Date())
            for (var j = 0; j < parkingSpaceCount; ++j)
                newParkingSpaces[i].push(app.model.createEmptyParkingSpaceModel(i, j))
        }

        // Specific for each garage
        newDescriptions[0].LocationName = "Augustinerhof"
        newDescriptions[0].Latitude = 49.45370
        newDescriptions[0].Longitude = 11.07515

        newDescriptions[1].LocationName = "Karlstadt"
        newDescriptions[1].Latitude = 49.45297
        newDescriptions[1].Longitude = 11.08270

        // All is ready, reassign properties to emit implicit signals
        updateStamps = newUpdateStamps
        descriptions = newDescriptions
        parkingSpaces = newParkingSpaces
        logs = newLogs
    }

    function addLogEntry(modelIndex)
    {
        var type = Math.round(Math.random() * 3)
        var total = descriptions[modelIndex].NumberTotalParkingSpaces
        var free = descriptions[modelIndex].NumberFreeParkingSpaces

        if (free === 0)
            addLogEntryFree(modelIndex)
        else if (free === total)
            addLogEntryOccupied(modelIndex)
        else if (type === 0)
            addLogEntryOccupied(modelIndex)
        else if (type === 1)
            addLogEntryFree(modelIndex)
        else if (type === 2)
            addLogEntryToBeOccupied(modelIndex)
        else
            addLogEntryToBeFree(modelIndex)
    }

    function addLogEntryOccupied(modelIndex)
    {
        var description = descriptions[modelIndex]
        var spaces = parkingSpaces[modelIndex]
        var log = logs[modelIndex]
        var onSiteId = getRandomParkingSpace(modelIndex, true)

        var entry = {
            "UserId": "Some ID",
            "Arrival": new Date().toString(),
            "GarageId": description.Id,
            "Status": "Occupied",
            "OnSiteId": onSiteId,
            "ParkingDuration": "0",
            "LicensePlateNumber": createRandomLicensePlate(),
            "Timestamp": new Date().toString(),
        }

        description.NumberFreeParkingSpaces--
        spaces[onSiteId] = entry
        log.push(entry)

        return entry
    }

    function addLogEntryToBeOccupied(modelIndex)
    {
        var description = descriptions[modelIndex]
        var spaces = parkingSpaces[modelIndex]
        var log = logs[modelIndex]
        var onSiteId = getRandomParkingSpace(modelIndex, true)

        var entry = {
            "UserId": "Some ID",
            "Arrival": "",
            "GarageId": description.Id,
            "Status": "ToBeOccupied",
            "OnSiteId": onSiteId,
            "ParkingDuration": "",
            "LicensePlateNumber": createRandomLicensePlate(),
            "Timestamp": new Date().toString(),
        }

        description.NumberFreeParkingSpaces--
        spaces[onSiteId] = entry
        log.push(entry)

        return entry
    }

    function addLogEntryFree(modelIndex)
    {
        var description = descriptions[modelIndex]
        var spaces = parkingSpaces[modelIndex]
        var log = logs[modelIndex]
        var onSiteId = getRandomParkingSpace(modelIndex, false)

        var entry = app.model.createEmptyParkingSpaceModel(modelIndex, onSiteId)
        description.NumberFreeParkingSpaces++
        spaces[onSiteId] = entry
        log.push(entry)
    }

    function addLogEntryToBeFree(modelIndex)
    {
        var spaces = parkingSpaces[modelIndex]
        var log = logs[modelIndex]
        var onSiteId = getRandomParkingSpace(modelIndex, false)

        var entry = spaces[onSiteId]
        entry.Status = "ToBeFree"
        entry.Timestamp = new Date().toString()
        log.push(entry)
    }

    function getRandomParkingSpace(modelIndex, free)
    {
        var spaces = parkingSpaces[modelIndex]
        var index = Math.round(Math.random() * (spaces.length - 1))

        var wrapCount = 0
        while (free !== (spaces[index].Status === "Free")) {
            if (++index === spaces.length) {
                index = 0
                if (++wrapCount == 2) {
                    // Should never happen...
                    console.trace()
                    print(JSON.stringify(spaces, 0, "   "))
                }
            }
        }

        return index
    }

    function createRandomLicensePlate()
    {
        var letters = String.fromCharCode(65 + (Math.random() * 7), 65 + (Math.random() * 7))
        var digits = 10000 + Math.round(Math.random() * 98000)
        return letters + digits
    }

    Timer {
        running: app.model.currentModel === root
        interval: 1000
        repeat: true
        onTriggered: {
            var modelIndex = Math.round(Math.random() * (descriptions.length - 1))
            var log = logs[modelIndex]
            addLogEntry(modelIndex)
            updateStamps[modelIndex] = new Date()

            var appendCount = 1
            var removeCount = 0

            if (log.length > app.model.maxLogLength) {
                // Trim log length:
                removeCount = app.model.maxLogLength / 2
                log.splice(0, removeCount)
            }

            app.model.updateTimeUpdated(modelIndex)
            app.model.descriptionUpdated(modelIndex)
            app.model.logUpdated(modelIndex, removeCount, appendCount)
            app.model.parkingSpacesUpdated(modelIndex)

            interval = Math.round(500 + (Math.random() * 5000))
        }
    }

}

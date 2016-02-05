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

        for (var i = 0; i < 2; ++i) {
            // Common for all garages
            newDescriptions.push({
                 Id: i,
                 NumberFreeParkingSpaces: 8,
                 NumberTotalParkingSpaces: 8,
             })
            newParkingSpaces.push([])
            newLogs.push([])
            newUpdateStamps.push(new Date())
            for (var j = 0; j < 8; ++j)
                newParkingSpaces[i].push(app.model.createEmptyParkingSpaceModel(i, j))
        }

        // Specific for each garage
        newDescriptions[0].LocationName = "Augustinerhof"
        newDescriptions[0].Latitude = 49.4530
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
        var type = Math.round(Math.random() * 2)
        var total = descriptions[modelIndex].NumberTotalParkingSpaces
        var free = descriptions[modelIndex].NumberFreeParkingSpaces

        if (free === 0)
            unparkCar(modelIndex)
        else if (free === total)
            parkCar(modelIndex)
        else if (type === 0)
            parkCar(modelIndex)
        else if (type === 1)
            unparkCar(modelIndex)
        else
            reserveCar(modelIndex)
    }

    function parkCar(modelIndex)
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
            "ParkingDuration": 0,
            "LicensePlateNumber": getRandomLicensePlate()
        }

        description.NumberFreeParkingSpaces--
        spaces[onSiteId] = entry
        log.push({message:entry.LicensePlateNumber + " arrived", time:new Date().toString(), type:"normal"})

        return entry
    }

    function reserveCar(modelIndex)
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
            "LicensePlateNumber": getRandomLicensePlate()
        }

        description.NumberFreeParkingSpaces--
        spaces[onSiteId] = entry
        log.push({message:entry.LicensePlateNumber + " reserved", time:new Date().toString(), type:"normal"})

        return entry
    }

    function unparkCar(modelIndex)
    {
        var description = descriptions[modelIndex]
        var spaces = parkingSpaces[modelIndex]
        var log = logs[modelIndex]
        var onSiteId = getRandomParkingSpace(modelIndex, false)

        log.push({message:spaces[onSiteId].LicensePlateNumber + " left", time:new Date().toString(), type:"normal"})
        description.NumberFreeParkingSpaces++
        spaces[onSiteId] = app.model.createEmptyParkingSpaceModel(modelIndex, onSiteId)
    }

    function getRandomParkingSpace(modelIndex, free)
    {
        var spaces = parkingSpaces[modelIndex]
        var index = Math.round(Math.random() * (spaces.length - 1))

        var wrapCount = 0
        var status = spaces[index].Status
        while ((free && status !== "Free") || (!free && status !== "Occupied" && status !== "ToBeOccupied")) {
            if (++index === spaces.length) {
                index = 0
                if (++wrapCount == 2) {
                    // Should never happen...
                    console.trace()
                    print(JSON.stringify(spaces, 0, "   "))
                }
            }
            status = spaces[index].Status
        }

        return index
    }

    function getRandomLicensePlate()
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

import QtQuick 2.4

Item {
    id: root

    // Note: these three arrays need to be in sync with regards
    // to index, since we don't use lookup on garage id.
    property var descriptions: []
    property var parkingSpaces: []
    property var logs: []

    Component.onCompleted: {
        createModels()
        fakeLogHistory(0)
        fakeLogHistory(1)

        for (var modelIndex = 0; modelIndex < descriptions.length; ++modelIndex) {
            app.model.descriptionUpdated(modelIndex)
            app.model.parkingSpacesUpdated(modelIndex)
            app.model.logUpdated(modelIndex, 0, 0)
        }
    }

    function update()
    {
        // no-op
    }

    function fakeLogHistory(modelIndex)
    {
        addLogEntry(modelIndex, 1)
        addLogEntry(modelIndex, 1)
        addLogEntry(modelIndex, 1)
        addLogEntry(modelIndex, 2)
        addLogEntry(modelIndex, 1)
        addLogEntry(modelIndex, 2)
        addLogEntry(modelIndex, 1)
    }

    function createModels()
    {
        var newDescriptions = new Array
        var newParkingSpaces = new Array
        var newLogs = new Array

        newDescriptions.push({
            Id: 0,
            LocationName: "Augustinerhof",
            NumberFreeParkingSpaces: 8,
            NumberTotalParkingSpaces: 8,
            Latitude: 49.45370,
            Longitude: 11.07515
        })
        newParkingSpaces.push([])
        newLogs.push([])
        for (var i = 0; i < 8; ++i)
            newParkingSpaces[0].push(app.model.createEmptyParkingSpaceObject(0, i))

        newDescriptions.push({
            Id: 1,
            LocationName: "Karlstadt",
            NumberFreeParkingSpaces: 8,
            NumberTotalParkingSpaces: 8,
            Latitude: 49.45297,
            Longitude: 11.08270
        })
        newParkingSpaces.push([])
        newLogs.push([])
        for (i = 0; i < 8; ++i)
            newParkingSpaces[1].push(app.model.createEmptyParkingSpaceObject(1, i))

        // Reassign properties to emit signals
        descriptions = newDescriptions
        parkingSpaces = newParkingSpaces
        logs = newLogs
    }

    function addLogEntry(modelIndex, type)
    {
        type = type === 0 ? Math.round(Math.random() * 10) : type
        var total = descriptions[modelIndex].NumberTotalParkingSpaces
        var free = descriptions[modelIndex].NumberFreeParkingSpaces

        if (free === 0 || (free !== total && (type % 2) === 0))
            unparkCar(modelIndex)
        else
            parkCar(modelIndex)
    }

    function parkCar(modelIndex)
    {
        var description = descriptions[modelIndex]
        var spaces = parkingSpaces[modelIndex]
        var log = logs[modelIndex]
        var onSiteId = getRandomParkingSpace(modelIndex, "Free")

        var entry = {
            "UserId": "Some ID",
            "Arrival": getCurrentTimeStamp(),
            "GarageId": description.Id,
            "Status": "Occupied",
            "OnSiteId": onSiteId,
            "ParkingDuration": 0,
            "LicensePlateNumber": "AB12345"
        }

        description.NumberFreeParkingSpaces--
        spaces[onSiteId] = entry
        log.push({message:"Vehicle has arrived", time:getCurrentTimeStamp(), type:"normal"})
    }

    function unparkCar(modelIndex)
    {
        var description = descriptions[modelIndex]
        var spaces = parkingSpaces[modelIndex]
        var log = logs[modelIndex]
        var onSiteId = getRandomParkingSpace(modelIndex, "Occupied")

        description.NumberFreeParkingSpaces++
        spaces[onSiteId] = app.model.createEmptyParkingSpaceObject(modelIndex, onSiteId)
        log.push({message:"Vehicle has left", time:getCurrentTimeStamp(), type:"normal"})
    }

    function getCurrentTimeStamp()
    {
        var time = new Date()
        var h = time.getHours()
        var m = time.getMinutes()
        h = (h < 10) ? "0" + h : h
        m = (m < 10) ? "0" + m : m
        return h + ":" + m
    }

    function getRandomParkingSpace(modelIndex, withStatus)
    {
        var spaces = parkingSpaces[modelIndex]
        var index = Math.round(Math.random() * (spaces.length - 1))

        var wrapCount = 0
        while (spaces[index].Status !== withStatus) {
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

    Timer {
        running: app.model.current === root
        interval: 1000
        repeat: true
        onTriggered: {
            var modelIndex = Math.round(Math.random() * (descriptions.length - 1))
            var log = logs[modelIndex]
            addLogEntry(modelIndex, 0)

            var appendCount = 1
            var removeCount = 0

            if (log.length > app.model.maxLogLength) {
                // Trim log length:
                removeCount = app.model.maxLogLength / 2
                log.splice(0, removeCount)
            }

            app.model.descriptionUpdated(modelIndex)
            app.model.logUpdated(modelIndex, removeCount, appendCount)
            app.model.parkingSpacesUpdated(modelIndex)

            interval = Math.round(500 + (Math.random() * 5000))
        }
    }

}

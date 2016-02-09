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
        createParkingLots()
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

    function createParkingLots()
    {
        var newDescriptions = []
        var newParkingSpaces = []
        var newLogs = []
        var newUpdateStamps = []
        var parkingSpaceCount = 8

        for (var i = 0; i < 2; ++i) {
            // Common for all parking lots
            newDescriptions.push({
                 Id: i,
                 numberFreeParkingSpaces: parkingSpaceCount,
                 numberTotalParkingSpaces: parkingSpaceCount,
             })
            newParkingSpaces.push([])
            newLogs.push([])
            newUpdateStamps.push(new Date())
            for (var j = 0; j < parkingSpaceCount; ++j)
                newParkingSpaces[i].push(app.model.createEmptyParkingSpaceModel(i, j))
        }

        // Specific for each parking lot
        newDescriptions[0].locationName = "Augustinerhof"
        newDescriptions[0].latitude = 49.45370
        newDescriptions[0].longitude = 11.07515

        newDescriptions[1].locationName = "Karlstadt"
        newDescriptions[1].latitude = 49.45297
        newDescriptions[1].longitude = 11.08270

        // We are now ready to assign "public" properties
        // (and emit implicit signals)
        updateStamps = newUpdateStamps
        descriptions = newDescriptions
        parkingSpaces = newParkingSpaces
        logs = newLogs
    }

    function addLogEntry(modelIndex)
    {
        var type = Math.round(Math.random() * 3)
        for (;;) {
            if (type === 0) {
                var parkingSpaceIndex = getRandomParkingSpaceWithStatus(modelIndex, "Free")
                if (parkingSpaceIndex !== -1) {
                    addLogEntryToBeOccupied(modelIndex, parkingSpaceIndex)
                    break
                }
            } else if (type === 1) {
                parkingSpaceIndex = getRandomParkingSpaceWithStatus(modelIndex, "ToBeOccupied")
                if (parkingSpaceIndex !== -1) {
                    addLogEntryOccupied(modelIndex, parkingSpaceIndex)
                    break
                }
            } else if (type === 2) {
                parkingSpaceIndex = getRandomParkingSpaceWithStatus(modelIndex, "Occupied")
                if (parkingSpaceIndex !== -1) {
                    addLogEntryToBeFree(modelIndex, parkingSpaceIndex)
                    break
                }
            } else {
                parkingSpaceIndex = getRandomParkingSpaceWithStatus(modelIndex, "ToBeFree")
                if (parkingSpaceIndex !== -1) {
                    addLogEntryFree(modelIndex, parkingSpaceIndex)
                    break
                }
            }

            if (++type == 4)
                type = 0
        }
    }

    function addLogEntryToBeOccupied(modelIndex, parkingSpaceIndex)
    {
        var description = descriptions[modelIndex]
        var spaces = parkingSpaces[modelIndex]
        var log = logs[modelIndex]

        var entryCopy = JSON.parse(JSON.stringify(spaces[parkingSpaceIndex]))
        entryCopy.status = "ToBeOccupied"
        entryCopy.licensePlateNumber = createRandomlicensePlateNumber()
        entryCopy.Timestamp = new Date().toString()

        spaces[parkingSpaceIndex] = entryCopy
        description.numberFreeParkingSpaces--
        log.push(entryCopy)
    }

    function addLogEntryOccupied(modelIndex, parkingSpaceIndex)
    {
        var description = descriptions[modelIndex]
        var spaces = parkingSpaces[modelIndex]
        var log = logs[modelIndex]

        var entryCopy = JSON.parse(JSON.stringify(spaces[parkingSpaceIndex]))
        entryCopy.arrival = new Date().toString()
        entryCopy.status = "Occupied"
        entryCopy.Timestamp = new Date().toString()

        spaces[parkingSpaceIndex] = entryCopy
        log.push(entryCopy)
    }

    function addLogEntryToBeFree(modelIndex, parkingSpaceIndex)
    {
        var description = descriptions[modelIndex]
        var spaces = parkingSpaces[modelIndex]
        var log = logs[modelIndex]

        var entryCopy = JSON.parse(JSON.stringify(spaces[parkingSpaceIndex]))
        entryCopy.status = "ToBeFree"
        entryCopy.Timestamp = new Date().toString()

        spaces[parkingSpaceIndex] = entryCopy
        log.push(entryCopy)
    }

    function addLogEntryFree(modelIndex, parkingSpaceIndex)
    {
        var description = descriptions[modelIndex]
        var spaces = parkingSpaces[modelIndex]
        var log = logs[modelIndex]

        var newEntry = app.model.createEmptyParkingSpaceModel(modelIndex, parkingSpaceIndex)
        description.numberFreeParkingSpaces++
        spaces[parkingSpaceIndex] = newEntry
        log.push(newEntry)
    }

    function createRandomlicensePlateNumber()
    {
        var letters = String.fromCharCode(65 + (Math.random() * 7), 65 + (Math.random() * 7))
        var digits = 10000 + Math.round(Math.random() * 98000)
        return letters + digits
    }

    function getRandomParkingSpaceWithStatus(modelIndex, status)
    {
        var spaces = parkingSpaces[modelIndex]
        var index = Math.round(Math.random() * (spaces.length - 1))
        var startIndex = index

        while (status !== spaces[index].status) {
            if (++index === spaces.length)
                index = 0
            if (index === startIndex)
                return -1
        }

        return index
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

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

    function reload()
    {
        update()
    }

    function update()
    {
        if (app.model.currentModel !== root)
            return
        for (var modelIndex = 0; modelIndex < descriptions.length; ++modelIndex) {
            app.model.updateTimeUpdated(modelIndex)
            app.model.descriptionUpdated(modelIndex)
            app.model.parkingSpacesUpdated(modelIndex)
            app.model.logUpdated(modelIndex, 0, 0)
        }
    }

    function fakeLogHistory(modelIndex)
    {
        var now = new Date()
        var count = 30
        var twoMin = 1000 * 60 * 2
        for (var i = 0; i < count; ++i) {
            var modificationDate = new Date(now.getTime() - ((count - i) * twoMin)).toISOString()
            addLogEntry(modelIndex, modificationDate)
        }
    }

    function createParkingLots()
    {
        var newDescriptions = []
        var newParkingSpaces = []
        var newLogs = []
        var newUpdateStamps = []

        for (var i = 0; i < 2; ++i) {
            // Common for all parking lots
            newDescriptions.push(app.model.createEmptyDescription(i))
            newParkingSpaces.push([])
            newLogs.push([])
            newUpdateStamps.push(new Date().toISOString())
            var now = new Date()
            for (var j = 0; j < newDescriptions[i].numberTotalParkingSpaces; ++j)
                newParkingSpaces[i].push(app.model.createEmptyParkingSpaceModel(i, j, now))
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

    function addLogEntry(modelIndex, modificationDate)
    {
        var type = Math.round(Math.random() * 3)
        for (;;) {
            if (type === 0) {
                var parkingSpaceIndex = getRandomParkingSpaceWithStatus(modelIndex, "Free")
                if (parkingSpaceIndex !== -1) {
                    addLogEntryBooked(modelIndex, parkingSpaceIndex, modificationDate)
                    break
                }
            } else if (type === 1) {
                parkingSpaceIndex = getRandomParkingSpaceWithStatus(modelIndex, "Booked")
                if (parkingSpaceIndex !== -1) {
                    addLogEntryOccupied(modelIndex, parkingSpaceIndex, modificationDate)
                    break
                }
            } else if (type === 2) {
                parkingSpaceIndex = getRandomParkingSpaceWithStatus(modelIndex, "Occupied")
                if (parkingSpaceIndex !== -1) {
                    addLogEntryToBeFree(modelIndex, parkingSpaceIndex, modificationDate)
                    break
                }
            } else {
                parkingSpaceIndex = getRandomParkingSpaceWithStatus(modelIndex, "ToBeFree")
                if (parkingSpaceIndex !== -1) {
                    addLogEntryFree(modelIndex, parkingSpaceIndex, modificationDate)
                    break
                }
            }

            if (++type == 4)
                type = 0
        }
    }

    function addLogEntryBooked(modelIndex, parkingSpaceIndex, modificationDate)
    {
        var description = descriptions[modelIndex]
        var spaces = parkingSpaces[modelIndex]
        var log = logs[modelIndex]

        var entryCopy = JSON.parse(JSON.stringify(spaces[parkingSpaceIndex]))
        entryCopy.status = "Booked"
        entryCopy.licensePlateNumber = createRandomlicensePlateNumber()
        entryCopy.modificationDate = modificationDate

        spaces[parkingSpaceIndex] = entryCopy
        description.numberFreeParkingSpaces--
        log.splice(0, 0, entryCopy)
    }

    function addLogEntryOccupied(modelIndex, parkingSpaceIndex, modificationDate)
    {
        var description = descriptions[modelIndex]
        var spaces = parkingSpaces[modelIndex]
        var log = logs[modelIndex]

        var entryCopy = JSON.parse(JSON.stringify(spaces[parkingSpaceIndex]))
        entryCopy.arrival = modificationDate
        entryCopy.status = "Occupied"
        entryCopy.modificationDate = modificationDate
        entryCopy.FAKE_parkingDuration_start = entryCopy.modificationDate

        spaces[parkingSpaceIndex] = entryCopy
        log.splice(0, 0, entryCopy)
    }

    function addLogEntryToBeFree(modelIndex, parkingSpaceIndex, modificationDate)
    {
        var description = descriptions[modelIndex]
        var spaces = parkingSpaces[modelIndex]
        var log = logs[modelIndex]

        var entryCopy = JSON.parse(JSON.stringify(spaces[parkingSpaceIndex]))
        entryCopy.status = "ToBeFree"
        entryCopy.modificationDate = modificationDate

        var startms = new Date(entryCopy.FAKE_parkingDuration_start).getTime()
        var endms = new Date(modificationDate).getTime()
        entryCopy.parkingDuration = Math.floor((endms - startms) / (1000 * 60))

        spaces[parkingSpaceIndex] = entryCopy
        log.splice(0, 0, entryCopy)
    }

    function addLogEntryFree(modelIndex, parkingSpaceIndex, modificationDate)
    {
        var description = descriptions[modelIndex]
        var spaces = parkingSpaces[modelIndex]
        var log = logs[modelIndex]

        var newEntry = app.model.createEmptyParkingSpaceModel(modelIndex, parkingSpaceIndex, modificationDate)

        description.numberFreeParkingSpaces++
        spaces[parkingSpaceIndex] = newEntry
        log.splice(0, 0, newEntry)
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
            addLogEntry(modelIndex, new Date().toISOString())
            updateStamps[modelIndex] = new Date().toISOString()

            var addCount = 1
            var removeCount = app.model.chopArray(log, app.model.maxLogLength)

            app.model.updateTimeUpdated(modelIndex)
            app.model.descriptionUpdated(modelIndex)
            app.model.logUpdated(modelIndex, addCount, removeCount)
            app.model.parkingSpacesUpdated(modelIndex)

            interval = Math.round(500 + (Math.random() * 5000))
        }
    }

}

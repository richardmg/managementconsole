import QtQuick 2.4

Item {
    id: root

    // Note: these three arrays need to be in sync with regards
    // to index, since we don't use lookup on garage id.
    property var descriptions: new Array
    property var parkingSpaces: new Array
    property var logs: new Array

    Component.onCompleted: {
        createModels()
        fakeLogHistory(0)
        fakeLogHistory(1)
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

        app.model.logUpdated(modelIndex)
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
        newParkingSpaces.push(new Array)
        newLogs.push(new Array)

        newDescriptions.push({
            Id: 1,
            LocationName: "Karlstadt",
            NumberFreeParkingSpaces: 8,
            NumberTotalParkingSpaces: 8,
            Latitude: 49.45297,
            Longitude: 11.08270
        })
        newParkingSpaces.push(new Array)
        newLogs.push(new Array)

        // Reassign properties to emit signals
        descriptions = newDescriptions
        parkingSpaces = newParkingSpaces
        logs = newLogs

        for (var modelIndex = 0; modelIndex < descriptions.length; ++modelIndex) {
            app.model.descriptionUpdated(modelIndex)
            app.model.parkingSpacesUpdated(modelIndex)
            app.model.logUpdated(modelIndex)
        }
    }

    function addLogEntry(modelIndex, type)
    {
        type = type === 0 ? Math.round(Math.random() * 10) : type

        var time = new Date()
        var h = time.getHours()
        var m = time.getMinutes()
        h = (h < 10) ? "0" + h : h
        m = (m < 10) ? "0" + m : m
        var timeStamp = h + ":" + m

        var description = descriptions[modelIndex]
        var log = logs[modelIndex]

        if (type === 10) {
            log.push({message:"Malfunction alert", time:timeStamp, type:"alert"})
        } else if (description.NumberFreeParkingSpaces === description.NumberTotalParkingSpaces) {
            description.NumberFreeParkingSpaces++
            log.push({message:"Vehicle has arrived", time:timeStamp, type:"normal"})
        } else if (description.NumberFreeParkingSpaces === 0 || (type % 2) === 0) {
            description.NumberFreeParkingSpaces--
            log.push({message:"Vehicle has left", time:timeStamp, type:"normal"})
        } else {
            description.NumberFreeParkingSpaces++
            log.push({message:"Vehicle has arrived", time:timeStamp, type:"normal"})
        }

        // Trim log length:
        if (log.length > 30)
            log.splice(0, log.length - 30)
    }

    function getEmptyParkingSpace(model)
    {
        var parkingSpace = Math.round(Math.random() * (model.spaceCapacity - 1))
        while (arrayContainsNumber(model.spacesOccupied, parkingSpace)) {
            parkingSpace++
            if (parkingSpace === model.spaceCapacity)
                parkingSpace = 0
        }
        return parkingSpace
    }

    function arrayContainsNumber(array, number)
    {
        for (var i = 0; i < array.length; ++i) {
            if (array[i] === number)
                return true
        }
        return false
    }

    Timer {
        running: app.model.current === root
        interval: 1000
        repeat: true
        onTriggered: {
            var modelIndex = Math.round(Math.random() * (descriptions.length - 1))
            addLogEntry(modelIndex, 0)
            app.model.descriptionUpdated(modelIndex)
            app.model.logUpdated(modelIndex)
//            interval = Math.round(500 + (Math.random() * 5000))
        }
    }

}

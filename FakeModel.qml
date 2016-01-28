import QtQuick 2.4

Item {
    id: root
    property var fakeModel: createFakeParkingLotModel()

//    Component.onCompleted: dumpFakeModel()
//    function dumpFakeModel()
//    {
//        addFakeLogEntry(fakeModel.parks[0], 1)
//        addFakeLogEntry(fakeModel.parks[0], 1)
//        addFakeLogEntry(fakeModel.parks[0], 1)
//        addFakeLogEntry(fakeModel.parks[0], 2)
//        parkModelUpdated(0)

//        addFakeLogEntry(fakeModel.parks[1], 1)
//        addFakeLogEntry(fakeModel.parks[1], 1)
//        addFakeLogEntry(fakeModel.parks[1], 10)
//        parkModelUpdated(1)

//        print(JSON.stringify(fakeModel, 0, " "))
//    }

    function getGarageIds() {
        return [0, 1]
    }

    function getGarageModel(garageId)
    {
        return fakeModel.parks[garageId]
    }

    function getParkingSpaceModel(garageId)
    {
        return {}
    }

    function getParkingSpaceLog(garageId)
    {
        return new Array
    }

    function createFakeParkingLotModel()
    {
        var parkModel = {
            parks: new Array
        }

        var park = {}
        park.garageId = 0
        park.parkName = "Augustinerhof"
        park.spaceCapacity = 8
        park.spacesOccupied = new Array
        park.latitude = 49.45370
        park.longitude = 11.07515
        park.log = new Array
        parkModel.parks.push(park)

        park = {}
        park.garageId = 1
        park.parkName = "Karlstadt"
        park.spaceCapacity = 8
        park.spacesOccupied = new Array
        park.latitude = 49.45297
        park.longitude = 11.08270
        park.log = new Array
        parkModel.parks.push(park)

        return parkModel
    }

    function addFakeLogEntry(model, type)
    {
        type = type === 0 ? Math.round(Math.random() * 10) : type

        var time = new Date()
        var h = time.getHours()
        var m = time.getMinutes()
        h = (h < 10) ? "0" + h : h
        m = (m < 10) ? "0" + m : m
        var timeStamp = h + ":" + m

        if (type === 10) {
            model.log.push({message:"Malfunction alert", time:timeStamp, type:"alert"})
        } else if (model.spacesOccupied.length === 0) {
            model.spacesOccupied.push(getEmptyParkingSpace(model))
            model.log.push({message:"Vehicle has arrived", time:timeStamp, type:"normal"})
        } else if (model.spacesOccupied.length >= model.spaceCapacity || (type % 2) === 0) {
            model.spacesOccupied.splice(-1, 1)
            model.log.push({message:"Vehicle has left", time:timeStamp, type:"normal"})
        } else {
            model.spacesOccupied.push(getEmptyParkingSpace(model))
            model.log.push({message:"Vehicle has arrived", time:timeStamp, type:"normal"})
        }

        // Trim log length:
        if (model.log.length > 30)
            model.log.splice(0, model.log.length - 30)
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
            var garageId = Math.round(Math.random() * (fakeModel.parks.length - 1))
            addFakeLogEntry(fakeModel.parks[garageId], 0)
            app.model.parkModelUpdated(garageId)
            interval = Math.round(500 + (Math.random() * 5000))
        }
    }

}

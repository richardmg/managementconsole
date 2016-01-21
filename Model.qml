import QtQuick 2.4
import QtWebSockets 1.0

QtObject {
    readonly property int kNoDataSource: 0
    readonly property int kFakeDataSource: 1
    readonly property int kRemoteDataSource: 2

    signal parkModelUpdated(int parkId)

    property int dataSource: kFakeDataSource
    onDataSourceChanged: {
        parkModelUpdated(0)
        parkModelUpdated(1)
    }

    function getAllParkIds() {
        if (dataSource === kNoDataSource)
            return [0, 1]
        else if (dataSource === kFakeDataSource)
            return [0, 1]
        else if (dataSource === kRemoteDataSource)
            return [0, 1]
    }

    function getParkingLotModel(id)
    {
        if (dataSource === kNoDataSource)
            return createEmptyParkingLotModel(id)
        else if (dataSource === kFakeDataSource)
            return getFakeParkingLotModel(id)
        else if (dataSource === kRemoteDataSource) {
            var model = createEmptyParkingLotModel()
            model.log.push({message:"Server mode", time:"00:01", icon:"error"})
            model.log.push({message:"not implemented!", time:"00:00", icon:"error"})
            return model
        }
    }

    function createEmptyParkingLotModel(id)
    {
        var model = {}

        model.parkId = -1
        model.isEmpty = true
        model.parkName = "[Empty]"
        model.latitude = 0
        model.longitude = 0
        model.spaceCapacity = 0
        model.spacesOccupied = []
        model.log = new Array

        return model
    }

    function getFakeParkingLotModel(id)
    {
        var model = {}

        if (id === 0) {
            model.parkId = 0
            model.parkName = "Augustinerhof"
            model.spaceCapacity = 8
            model.spacesOccupied = [0, 1, 2, 3]
            model.freeSpaces = 6
            model.latitude = 49.45370
            model.longitude = 11.07515

            var log = new Array
            log.push({message:"Vehicle has left", time:"10:45", icon:"normal"})
            log.push({message:"Malfunction Alert", time:"09:37", icon:"warning"})
            log.push({message:"Vehicle has arrived", time:"09:28", icon:"normal"})
            log.push({message:"Vehicle has left", time:"09:02", icon:"normal"})
            model.log = log
        } else if (id === 1) {
            model.parkId = 1
            model.parkName = "Karlstadt"
            model.spaceCapacity = 8
            model.spacesOccupied = [3, 4, 6]
            model.freeSpaces = "Full"
            model.latitude = 49.45297
            model.longitude = 11.08270

            log = new Array
            log.push({message:"Vehicle has arrived", time:"10:45", icon:"normal"})
            log.push({message:"Vehicle has left", time:"10:10", icon:"normal"})
            log.push({message:"Vehicle has arrived", time:"09:22", icon:"normal"})
            log.push({message:"Vehicle has arrived", time:"09:21", icon:"normal"})
            log.push({message:"Vehicle has left", time:"09:13", icon:"normal"})
            model.log = log
        } else {
            model = createEmptyParkingLotModel()
            log.push({message:"Error: requested park ID does not exist: " + id, time:"00:00", icon:"error"})
        }

        return model
    }
}

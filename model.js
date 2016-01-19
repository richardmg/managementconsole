.pragma library

var kNoDataSource = 0
var kFakeDataSource = 1
var kRemoteDataSource = 2

var dataSource = kNoDataSource

function createEmptyParkingLotModel(id)
{
    var model = {}

    model.parkId = -1
    model.emptyParkModel = true
    model.parkName = "[Empty]"
    model.freeSpaces = "Empty"
    model.latitude = 0
    model.longitude = 0
    model.log = new Array

    return model
}

function getFakeParkingLotModel(id)
{
    var model = {}

    if (id === 0) {
        model.parkId = 0
        model.parkName = "Augustinerhof"
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
        model = createEmptyParkingLotModel()
        log.push({message:"Error: kRemoveDataSource NOT YET IMPLEMENTED!", time:"00:00", icon:"error"})
        return model
    }
}


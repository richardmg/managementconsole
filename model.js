.pragma library

function getAllParkIds() {
    return [0, 1]
}

function getParkingLotModel(id) {
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
    }

    return model
}


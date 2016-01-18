.pragma library

function getParkingLotModel(id) {
    var model = {}

    var log = new Array
    log.push({message:"Vehicle has left", time:"10:45", icon:"normal"})
    log.push({message:"Malfunction Alert", time:"09:37", icon:"warning"})
    log.push({message:"Vehicle has arrived", time:"09:28", icon:"normal"})
    log.push({message:"Vehicle has left", time:"09:02", icon:"normal"})
    model.log = log

    return model
}


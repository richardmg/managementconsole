.pragma library

function getParkingLotHistory(id) {
    var history = new Array
    history.push({message:"Vehicle has left", time:"10:45", icon:"normal"})
    history.push({message:"Malfunction Alert", time:"09:37", icon:"warning"})
    history.push({message:"Vehicle has arrived", time:"09:28", icon:"normal"})
    history.push({message:"Vehicle has left", time:"09:02", icon:"normal"})
    return history
}


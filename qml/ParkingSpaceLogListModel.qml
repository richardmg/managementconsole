import QtQuick 2.0

ListModel {
    id: listModel

    property int modelIndex: -1

    Component.onCompleted: updateModel(modelIndex, -1, 0)

    property var connections: Connections {
        target: app.model
        onLogUpdated: updateModel(modelIndex, addCount, removeCount)
    }

    function updateModel(modelIndex, addCount, removeCount)
    {
        if (modelIndex !== parkLog.modelIndex)
            return

        var log = app.model.currentModel.logs[modelIndex]
        if (!log)
            return

//        print("update", app.model.currentModel.descriptions[modelIndex].locationName + ":", "addCount:", addCount, "removeCount:", removeCount)

        // We get notified how many entries that were removed from the
        // end of the log, and how many that were prepended in front.
        // If addCount === -1, it means the whole log needs to update.
        if (addCount === -1) {
            listModel.clear()
            addCount = log.length
        }

        if (removeCount > 0)
            listModel.remove(listModel.count - removeCount, removeCount)

        for (var i = addCount - 1; i >= 0; --i) {
            var entry = log[i]

            var licensePlate = entry.licensePlateNumber ? entry.licensePlateNumber : "Car"

            if (entry.status === "Free")
                entry.message = "Space " + entry.parkingSpaceOnSiteId + " is now free"
            else if (entry.status === "Occupied")
                entry.message = licensePlate + " arrived at space " + entry.parkingSpaceOnSiteId
            else if (entry.status === "Booked")
                entry.message = licensePlate + " booked space " + entry.parkingSpaceOnSiteId
            else if (entry.status === "ToBeOccupied")
                entry.message = licensePlate + " enters parking lot"
            else if (entry.status === "ToBeFree")
                entry.message = licensePlate + " is leaving space " + entry.parkingSpaceOnSiteId
            else if (entry.status === "Malfunction")
                entry.message = "Malfunction on space " + entry.parkingSpaceOnSiteId
            else {
                print("WARNING: Unknown parking space status:", entry.status)
                entry.message = "Unknown event at " + entry.parkingSpaceOnSiteId
            }

            listModel.insert(0, entry)
        }
    }
}

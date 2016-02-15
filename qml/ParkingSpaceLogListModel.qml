import QtQuick 2.0

ListModel {
    id: listModel

    property int modelIndex: -1

    Component.onCompleted: updateModel(modelIndex, 0, 0)

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

        // We get notified how many entries that were removed from the
        // end of the log, and how many that were prepended in front.
        // If both are zero, it means the whole log was changed.
        if (addCount === 0 && removeCount === 0) {
            listModel.clear()
            addCount = log.length
        }

        if (removeCount > 0)
            listModel.remove(listModel.count - removeCount, removeCount)

        for (var i = addCount - 1; i >= 0; --i) {
            var entry = log[i]

            if (entry.status === "Free")
                entry.message = "Space " + entry.parkingSpaceOnSiteId + " is now free"
            else if (entry.status === "Occupied")
                entry.message = entry.licensePlateNumber + " arrived at space " + entry.parkingSpaceOnSiteId
            else if (entry.status === "ToBeOccupied")
                entry.message = entry.licensePlateNumber + " reserved space " + entry.parkingSpaceOnSiteId
            else if (entry.status === "ToBeFree")
                entry.message = entry.licensePlateNumber + " is leaving space " + entry.parkingSpaceOnSiteId
            else if (entry.status === "Malfunction")
                entry.message = "Malfunction on space " + entry.parkingSpaceOnSiteId
            else
                entry.message = "Unknown event at " + entry.parkingSpaceOnSiteId

            listModel.insert(0, entry)
        }
    }
}

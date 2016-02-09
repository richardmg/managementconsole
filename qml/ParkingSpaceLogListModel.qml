import QtQuick 2.0

ListModel {
    id: listModel

    property int modelIndex: -1

    Component.onCompleted: updateModel(modelIndex, 0, 0)

    property var connections: Connections {
        target: app.model
        onLogUpdated: updateModel(modelIndex, removed, appended)
    }

    function updateModel(modelIndex, removed, appended)
    {
        if (modelIndex !== parkLog.modelIndex)
            return

        var log = app.model.currentModel.logs[modelIndex]
        if (!log)
            return

        // We get notified how many entries that were removed from the
        // beginning of the log, and how many that were added to the end.
        // If both are zero, it means the whole log was changed.
        if (removed === 0 && appended === 0) {
            listModel.clear()
            appended = log.length
        }

        // We reverse the log, since we want the
        // newest entries to show up on top
        if (removed > 0)
            listModel.remove(listModel.count - removed, removed)

        for (var i = log.length - appended; i < log.length; ++i) {
            var entry = log[i]

            if (entry.status === "Free")
                entry.Message = "Space " + entry.onSiteId + " is now free"
            else if (entry.status === "Occupied")
                entry.Message = entry.licensePlateNumber + " arrived at space " + entry.onSiteId
            else if (entry.status === "ToBeOccupied")
                entry.Message = entry.licensePlateNumber + " reserved space " + entry.onSiteId
            else if (entry.status === "ToBeFree")
                entry.Message = entry.licensePlateNumber + " is leaving space " + entry.onSiteId
            else if (entry.status === "Malfunction")
                entry.Message = "Malfunction on space " + entry.onSiteId
            else entry.Message = ""

            listModel.insert(0, entry)
        }
    }
}

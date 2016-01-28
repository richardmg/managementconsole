import QtQuick 2.4
import QtWebSockets 1.0

Item {
    // Proxy model

    property var current: xmlHttpRequestModel
    property bool loggingActive: true

    signal idsUpdated()
    signal descriptionUpdated(int garageId)
    signal parkingSpacesUpdated(int garageId)
    signal logUpdated(int garageId)

    property var fakeModel: FakeModel {}
    property var xmlHttpRequestModel: XmlHttpRequestModel {}

    Component.onCompleted: current.update()
    onCurrentChanged: current.update()

    onIdsUpdated: {
        if (!loggingActive)
            return

        print("Garage IDs updated:", current.getIds())
    }

    onDescriptionUpdated: {
        if (!loggingActive)
            return

        print("Description updated:", garageId, JSON.stringify(current.getDescription(garageId), 0, "   "))
    }

    function createEmptyDescription()
    {
        return {
            "EMPTY_DESCRIPTION_GENERATED_LOCALLY": true,
            "Id": 0,
            "LocationName": "",
            "Latitude": 0,
            "Longitude": 0,
            "NumberFreeParkingSpaces": 0,
            "NumberTotalParkingSpaces": 1
        }
    }

    function createEmptyParkingSpaceObject()
    {
        return new Object
    }
}

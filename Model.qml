import QtQuick 2.4
import QtWebSockets 1.0

Item {
    // Proxy model

    property var current: fakeModel
    property bool loggingActive: false

    signal descriptionUpdated(int modelIndex)
    signal parkingSpacesUpdated(int modelIndex)
    signal logUpdated(int modelIndex)

    property var fakeModel: FakeModel {}
    property var xmlHttpRequestModel: XmlHttpRequestModel {}

    Component.onCompleted: current.update()
    onCurrentChanged: current.update()

    onDescriptionUpdated: {
        if (!loggingActive)
            return

        print("Description updated:", modelIndex, JSON.stringify(current.descriptions[modelIndex], 0, "   "))
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

    function createEmptyLog()
    {
        return new Array
    }
}

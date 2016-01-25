import QtQuick 2.4
import QtWebSockets 1.0

Item {
    readonly property int kNoDataSource: 0
    readonly property int kFakeDataSource: 1
    readonly property int kRemoteDataSource: 2

    signal parkModelUpdated(int parkId)

    property int dataSource: kFakeDataSource
    onDataSourceChanged: {
        parkModelUpdated(0)
        parkModelUpdated(1)
    }

    property var fakeModel: createFakeParkingLotModel()
    property alias webSocket: webSocket

    function getParkIds() {
        if (dataSource === kNoDataSource)
            return [0, 1]
        else if (dataSource === kFakeDataSource)
            return [0, 1]
        else if (dataSource === kRemoteDataSource)
            return [0, 1]
    }

    function getParkModel(id)
    {
        if (dataSource === kNoDataSource)
            return createEmptyParkingLotModel(id)
        else if (dataSource === kFakeDataSource)
            return fakeModel.parks[id]
        else if (dataSource === kRemoteDataSource)
            return fakeModel.parks[id]
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

    function createFakeParkingLotModel()
    {
        var parkModel = {
            parks: new Array
        }

        var park = {}
        park.parkId = 0
        park.parkName = "Augustinerhof"
        park.spaceCapacity = 8
        park.spacesOccupied = [0, 1, 2, 3]
        park.latitude = 49.45370
        park.longitude = 11.07515
        var log = new Array
        log.push({message:"Vehicle has left", time:"10:45", icon:"normal"})
        log.push({message:"Malfunction Alert", time:"09:37", icon:"alert"})
        log.push({message:"Vehicle has arrived", time:"09:28", icon:"normal"})
        log.push({message:"Vehicle has left", time:"09:02", icon:"normal"})
        park.log = log
        parkModel.parks.push(park)

        park = {}
        park.parkId = 1
        park.parkName = "Karlstadt"
        park.spaceCapacity = 8
        park.spacesOccupied = [0, 1, 2, 3, 4, 5, 6, 7]
        park.latitude = 49.45297
        park.longitude = 11.08270
        log = new Array
        log.push({message:"Vehicle has arrived", time:"10:45", icon:"normal"})
        log.push({message:"Vehicle has left", time:"10:10", icon:"normal"})
        log.push({message:"Vehicle has arrived", time:"09:22", icon:"normal"})
        log.push({message:"Vehicle has arrived", time:"09:21", icon:"normal"})
        log.push({message:"Vehicle has left", time:"09:13", icon:"normal"})
        park.log = log
        parkModel.parks.push(park)

        return parkModel
    }

//    Component.onCompleted: dumpModel()
//    function dumpModel()
//    {
//        print(JSON.stringify(getFakeParkingLotModel(0, 0, '\t')))
//    }

    // Move this into separate component?

    WebSocket {
        id: webSocket
        active: dataSource == kRemoteDataSource

        onTextMessageReceived: {
            print("Received message:", message)
        }
    }

}

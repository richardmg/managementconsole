import QtQuick 2.4
import QtWebSockets 1.0

Item {
    readonly property int kFakeDataSource: 1
    readonly property int kRemoteDataSource: 2

    property int dataSource: kFakeDataSource
    property alias webSocket: webSocket
    property bool loggingActive: true

    signal garageModelUpdated()
    signal parkModelUpdated(int parkId)

    property var _fakeModel: FakeModel {}
    property var _xmlHttpRequestModel: XmlHttpRequestModel {}

    onDataSourceChanged: {
        var ids = getParkIds()
        for (var i = 0; i < ids.length; ++i)
            parkModelUpdated(ids[i])
    }

    onGarageModelUpdated: {
        if (!loggingActive)
            return

        print("Garage model updated:", getParkIds())
    }

    function getParkIds() {
        if (dataSource === kFakeDataSource)
            return _fakeModel.getParkIds()
        else if (dataSource === kRemoteDataSource)
            return _xmlHttpRequestModel.getParkIds()
    }

    function getParkModel(id)
    {
        if (dataSource === kFakeDataSource)
            return _fakeModel.getParkModel(id)
        else if (dataSource === kRemoteDataSource)
            return 0
    }

    function getGarageModel(id)
    {
        if (dataSource === kFakeDataSource)
            return _fakeModel.getParkModel(id)
        else if (dataSource === kRemoteDataSource)
            return 0
    }

    WebSocket {
        id: webSocket
        active: dataSource == kRemoteDataSource

        onTextMessageReceived: {
            print("Received message:", message)
        }
    }

}

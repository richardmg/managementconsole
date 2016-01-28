import QtQuick 2.0

Item {
    property string baseUrl: "http://cloudparkingdemo.azurewebsites.net/api/tdxremote/"

    Component.onCompleted: load("garage", dumpResponse)

    function load(action, callback)
    {
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function() {
            if (xmlhttp.readyState === XMLHttpRequest.DONE) {
                if (xmlhttp.status == 200) {
                    callback(xmlhttp.responseText)
                } else {
                    print("WARNING! could not get data from server:", xmlhttp.statusText)
                }
            }
        }

        xmlhttp.open("GET", baseUrl + action, true);
        xmlhttp.send();
    }

    function dumpResponse(responseText)
    {
        print(JSON.stringify(JSON.parse(responseText), 0, "   "))
    }

}

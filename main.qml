import QtQuick 2.4
import QtQuick.Window 2.1
import QtLocation 5.5
import QtPositioning 5.5
import QtQuick.Controls 1.4

Window {
    id: app
    width: 1024
    height: 600
    visible: true
    visibility: Window.AutomaticVisibility

    // Style props:

    property color colorDarkLine: Qt.rgba(0.3, 0.3, 0.3, 1.0)
    property color colorLightLine: Qt.rgba(0.6, 0.6, 0.6, 1.0)
    property color colorSelectedBg: Qt.rgba(0.9, 0.9, 0.9, 1.0)

    property FontMetrics fontBig: FontMetrics { font.family: "verdana"; font.pixelSize: 24 }
    property FontMetrics fontNormal: FontMetrics { font.family: "verdana"; font.pixelSize: 18 }
    property FontMetrics fontSmall: FontMetrics { font.family: "verdana"; font.pixelSize: 14 }

    property real margin: 10
    property real spacing: 10

    // Global API:

    property Model model: Model{}
    property TopView currentView: mainView
    property alias mainView: mainView
    property alias settingsView: settingsView

    Button {
        anchors.right: parent.right
        text: "Settings"
        onClicked: currentView = settingsView
    }

    Row {
        Button {
            text: "MainView"
            onClicked: currentView = mainView
        }
    }

    MainView {
        id: mainView
    }

    Settings {
        id: settingsView
    }
}

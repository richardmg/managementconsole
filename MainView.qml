import QtQuick 2.4
import QtQuick.Window 2.1
import QtLocation 5.5
import QtPositioning 5.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2

TopView {
    property alias parkMap: parkMap
    property int selectedParkId: -1

    SplitView {
        anchors.fill: parent
        handleDelegate: Item { width: app.spacingHor }

        ParkMap {
            id: parkMap
            Layout.fillWidth: true
        }

        SplitView {
            orientation: Qt.Vertical
            handleDelegate: Item { height: app.spacingVer }
            width: 320

            ParkLog {
                id: parkA
                height: (parent.height - app.spacingVer) / 2
                parkId: 0
            }

            ParkLog {
                id: parkB
                parkId: 1
            }
        }
    }
}

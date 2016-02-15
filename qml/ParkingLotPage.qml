import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2

import "qrc:/components/qml"

TopLevelPage {
    id: root
    property int modelIndex: -1

    SplitView {
        anchors.fill: parent
        handleDelegate: Item { width: app.spacingHor }

        ParkingLotMap {
            border.color: app.colorDarkBg
            Layout.fillWidth: true
            modelIndex: root.modelIndex
        }

        SplitView {
            id: verticalSplit
            orientation: Qt.Vertical
            handleDelegate: Item { height: app.spacingVer }
            width: 350

            ExpandableContainer {
                id: imageContainer
                width: parent.width
                height: webcam.implicitHeight
                expandTo: root

                WebCam {
                    id: webcam
                    width: parent.width
                    height: parent.height
                    modelIndex: root.modelIndex
                    expandableContainer: imageContainer
                }
            }

            ParkingLotLog {
                id: parkB
                Layout.fillHeight: true
                modelIndex: root.modelIndex
                showMapIcon: false
                showPercentage: false
                showExpandIcon: true
                showDate: true
                width: parent.width
                height: parent.height
                expandableContainer: parkDetailsContainer
            }
        }
    }

    ExpandableContainer {
        id: parkDetailsContainer
        visible: false
        expandTo: root

        SubPage {
            onClose: parkDetailsContainer.expanded = false
            iconBaseName: "Contract"

            ParkingLotLogDetails {
                anchors.fill: parent
                modelIndex: root.modelIndex
            }
        }
    }


}


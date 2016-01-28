import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2

import "qrc:/components"

AppPage {
    id: root
    property int modelIndex: -1

    SplitView {
        anchors.fill: parent
        handleDelegate: Item { width: app.spacingHor }

        ParkDetailMap {
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
                    expandableContainer: imageContainer
                }
            }

            ExpandableContainer {
                id: parkContainer
                expandTo: root
                Layout.fillHeight: true

                ParkLog {
                    id: parkB
                    modelIndex: root.modelIndex
                    showMapIcon: false
                    showPercentage: false
                    showExpandIcon: true
                    showDate: true
                    width: parent.width
                    height: parent.height
                    expandableContainer: parkContainer
                }
            }
        }
    }

}


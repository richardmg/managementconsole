import QtQuick 2.0

Rectangle {
    id: root
    anchors.fill: parent
    anchors.margins: margin
    anchors.topMargin: 110
    anchors.bottomMargin: 20
    anchors.rightMargin: app.contentLeftMargin
    anchors.leftMargin: app.contentLeftMargin
    visible: app.currentView == root
}


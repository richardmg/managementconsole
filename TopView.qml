import QtQuick 2.0

Rectangle {
    id: root
    anchors.fill: parent
    anchors.margins: margin
    anchors.topMargin: 100
    anchors.rightMargin: app.contentLeftMargin
    anchors.leftMargin: app.contentLeftMargin
    visible: app.currentView == root
}


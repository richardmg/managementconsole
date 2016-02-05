#include <QtGui>
#include <QtQml>
#include <QtQuick>
#include <QApplication>

int main(int argc, char **argv){
    QApplication app(argc, argv);
    QQmlApplicationEngine engine(QUrl("qrc:///main.qml"));
    return app.exec();
}


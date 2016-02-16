#include <QtGui>
#include <QtQml>
#include <QtQuick>
#include <QApplication>

int main(int argc, char **argv){
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    QApplication app(argc, argv);
    QQmlApplicationEngine engine(QUrl("qrc:///qml/main.qml"));
    return app.exec();
}


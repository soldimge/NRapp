#include <QtCore/QUrl>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQml/QQmlContext>

#include "QtAndroidTools.h"
#include "appcoredim.h"
#include "keepawake.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    qputenv("QT_QUICK_CONTROLS_STYLE", "material");
    KeepAwake lock;

    app.setOrganizationName("Belarus radio");
    app.setOrganizationDomain("soldimge@gmail.com");
    app.setApplicationName("Belarus radio");

    QtAndroidTools::initializeQmlTools();

    AppCoreDim backEnd;
    QQmlApplicationEngine engine;
    QQmlContext *context = engine.rootContext();

    context->setContextProperty("backEnd", &backEnd);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}







#include <QtCore/QUrl>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQml/QQmlContext>
#include <QtWebView/QtWebView>

#include "appcoredim.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QtWebView::initialize();
    QGuiApplication app(argc, argv);
    AppCoreDim backEnd;
    QQmlApplicationEngine engine;
    QQmlContext *context = engine.rootContext();

    context->setContextProperty("backEnd", &backEnd);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}














//class Utils : public QObject {
//    Q_OBJECT
//public:
//    Utils(QObject* parent = 0) : QObject(parent) { }
//    Q_INVOKABLE static QUrl fromUserInput(const QString& userInput);
//};

//QUrl Utils::fromUserInput(const QString& userInput)
//{
//    if (userInput.isEmpty())
//        return QUrl::fromUserInput("about:blank");
//    const QUrl result = QUrl::fromUserInput(userInput);
//    return result.isValid() ? result : QUrl::fromUserInput("about:blank");
//}

//#include "main.moc"


//    context->setContextProperty(QStringLiteral("utils"), new Utils(&engine));
//    QCommandLineParser parser;
//    QCoreApplication::setApplicationVersion(QT_VERSION_STR);
//    parser.setApplicationDescription(QGuiApplication::applicationDisplayName());
//    parser.addHelpOption();
//    parser.addVersionOption();
//    parser.addPositionalArgument("url", "The initial URL to open.");
//    QStringList arguments = app.arguments();
//    parser.process(arguments);
//    const QString initialUrl = QStringLiteral("https://live.novoeradio.by:444/live/novoeradio_aac128/icecast.audio");

//    context->setContextProperty(QStringLiteral("initialUrl"),
//                                Utils::fromUserInput(initialUrl));
//    QRect geometry = QGuiApplication::primaryScreen()->availableGeometry();
//    if (!QGuiApplication::styleHints()->showIsFullScreen()) {
//        const QSize size = geometry.size() * 4 / 5;
//        const QSize offset = (geometry.size() - size) / 2;
//        const QPoint pos = geometry.topLeft() + QPoint(offset.width(), offset.height());
//        geometry = QRect(pos, size);
//    }
//    context->setContextProperty(QStringLiteral("initialX"), geometry.x());
//    context->setContextProperty(QStringLiteral("initialY"), geometry.y());
//    context->setContextProperty(QStringLiteral("initialWidth"), geometry.width());
//    context->setContextProperty(QStringLiteral("initialHeight"), geometry.height());

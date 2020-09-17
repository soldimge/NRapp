#ifndef APPCOREDIM_H
#define APPCOREDIM_H
#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QTextCodec>
#include <QString>
#include <QRegExp>

#include <QTimer>
#include <QTime>
#include <QtAndroid>

class AppCoreDim : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString notification READ notification WRITE setNotification NOTIFY notificationChanged)

public:
    explicit AppCoreDim(QObject *parent = nullptr);
    ~AppCoreDim();
    Q_INVOKABLE void but_click(short);
    Q_INVOKABLE void retry();
    void findPic();
    void work();
    QNetworkAccessManager* manager;
    void setNotification(const QString &notification);
    QString notification() const;
    void cancel();

private:
    QTimer* tmr;
    QUrl urlUser;
    QString song1;
    QString song2;
    QString song4;
    QString pic1;
    short song_num;
    short id;
    QString m_notification;

signals:
    // Сигнал для передачи данных в qml-интерфейс
    void sendToQml(QString song1, QString song2, QString song4);
    void sendToQml_ID(short id);
    void sendToQml_pic(QString pic1);
    void notificationChanged();
    void netError();

public slots:
    void picReplyFinished();
    void replyFinished();
    void updateTime();
    void updateAndroidNotification();
};

#endif // APPCOREDIM_H

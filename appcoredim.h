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

private:
    QNetworkAccessManager* manager;
    QTimer* tmr;
    QUrl urlUser;
    QString song;
    QString pic1;
    qint16 id;
    QString m_notification;
    void findPic();
    void work();
    void setNotification(const QString &notification);
    QString notification() const;
    void cancel();

signals:
    void sendToQml(QString song);
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

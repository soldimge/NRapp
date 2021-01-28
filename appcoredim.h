#pragma once
#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QTextCodec>
#include <QString>
#include <QRegExp>
#include <QTimer>
#include <QTime>
#include <QSettings>

#include <QAndroidJniObject>
#include <QAndroidJniEnvironment>

class AppCoreDim : public QObject
{
    Q_OBJECT
public:
    explicit AppCoreDim(QObject *parent = nullptr);
    ~AppCoreDim();
    Q_INVOKABLE void but_click(qint16);
    Q_INVOKABLE void retry();

private:
    QNetworkAccessManager* _manager;
    QTimer* _tmr;
    QUrl _urlUser;
    QString _song;
    QString _pic1;
    QString _homepage;
    qint16 _id;
    QString _mNotification;
    QSettings _settings;

    static bool _mediaRegistered;
    static bool _isPlaying;

    void findPic();
    void work();
    void homePage();
    void cancel();
    void emitStop(){emit stop();}
    void emitPlay(){emit play();}
    static void audioFocusLoss(JNIEnv *env, jobject thiz);
    static void audioFocusGain(JNIEnv *env, jobject thiz);
    static AppCoreDim* ptr;

signals:
    void sendToQml(QString song);
    void sendToQml_pic(QString pic1);
    void netError();
    void sendToQml_homePage(QString homepage, QString radioLogo);
    void sendSettings(qint16 id);
    void stop();
    void play();

public slots:
    void picReplyFinished();
    void replyFinished();
    void HPReplyFinished();
    void updateTime();
};


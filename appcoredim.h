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
#include <QSettings>

class AppCoreDim : public QObject
{
    Q_OBJECT
public:
    explicit AppCoreDim(QObject *parent = nullptr);
    ~AppCoreDim();
    Q_INVOKABLE void but_click(qint16);
    Q_INVOKABLE void retry();
    Q_INVOKABLE void setVolume(qint16);

private:
    QNetworkAccessManager* manager;
    QTimer* tmr;
    QUrl urlUser;
    QString song;
    QString pic1;
    QString homepage;
    qint16 id;
    qint16 volume;
    QString m_notification;
    QSettings settings;
    void findPic();
    void work();
    void homePage();
    void cancel();

signals:
    void sendToQml(QString song);
    void sendToQml_pic(QString pic1);
    void netError();
    void sendToQml_homePage(QString homepage, QString radioLogo);
    void sendSettings(qint16 id, qint16 volume);

public slots:
    void picReplyFinished();
    void replyFinished();
    void HPReplyFinished();
    void updateTime();
};

#endif // APPCOREDIM_H

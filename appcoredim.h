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

class AppCoreDim : public QObject
{
    Q_OBJECT
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
    QString homepage;
    qint16 id;
    QString m_notification;
    void findPic();
    void work();
    void homePage();
    void cancel();

signals:
    void sendToQml(QString song);
    void sendToQml_pic(QString pic1);
    void netError();
    void sendToQml_homePage(QString homepage, QString radioLogo);

public slots:
    void picReplyFinished();
    void replyFinished();
    void HPReplyFinished();
    void updateTime();
};

#endif // APPCOREDIM_H

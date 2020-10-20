#include "appcoredim.h"

AppCoreDim::AppCoreDim(QObject *parent) : QObject(parent),
                                          manager(new QNetworkAccessManager(this)),
                                          tmr(new QTimer()),
                                          id(0)
{
    connect(this, SIGNAL(notificationChanged()), this, SLOT(updateAndroidNotification()));
    tmr->setInterval(3000);
    connect(tmr, SIGNAL(timeout()), this, SLOT(updateTime()));
    updateTime();
    tmr->start();
}

AppCoreDim::~AppCoreDim()
{
    cancel();
    delete manager;
    delete tmr;
}

void AppCoreDim::but_click(qint16 i)
{
    id = i;
}

void AppCoreDim::retry()
{
    tmr->start();
}

void AppCoreDim::findPic()
{
    QNetworkRequest request(urlUser);
    QNetworkReply *myReply = manager->get(request);
    connect(myReply, &QNetworkReply::finished, this, &AppCoreDim::picReplyFinished);
}

void AppCoreDim::work()
{
    QNetworkRequest request(urlUser);
    QNetworkReply *myReply = manager->get(request);
    connect(myReply, &QNetworkReply::finished, this, &AppCoreDim::replyFinished);
}

void AppCoreDim::replyFinished()
{
  QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
  if (reply->error() == QNetworkReply::NoError)
  {
      QByteArray content= reply->readAll();
      song = content.data();

      QRegExp rgx1("</span></td>\\s*.*class=\"ajax\">(.*)</a></td>");
      QRegExp rgx2("<td>(\\w.*)<");

      qDebug() << "индекс rgx1" << song.indexOf(rgx1, 0) << "индекс rgx2" << song.indexOf(rgx2, 0);

      if (song.indexOf(rgx1, 0) < song.indexOf(rgx2, 0) && song.indexOf(rgx1, 0)!= -1)
      {
          rgx1.indexIn(song);
          song = rgx1.cap(1);
          song = song.left(song.indexOf("</a></td>"));
      }
      else
      {
          rgx2.indexIn(song);
          song = rgx2.cap(1);
          song = song.left(song.indexOf("</td>"));
      }

      song.replace("&amp;", "&");
      song.replace("&#34", "'");
      song.replace("&#39;", "`");
      song.replace(" - ", "\n");
      song.replace(";", "&");
      song = song.left(song.indexOf("["));

      emit sendToQml(song);
      QString temp = m_notification;
      switch (id)
      {
        case 4 : m_notification = "Радио РОКС"; break;
//        case 18 : m_notification = "Центр FM"; break;
        default: m_notification = song; break;
      }
      m_notification.replace("<b>","");
      m_notification.replace("</b>","");
      if (temp != m_notification)
          emit notificationChanged();
  }
  else
  {
//      qDebug() << reply->errorString();
      tmr->stop();
      emit netError();
  }
  reply->deleteLater();
}

void AppCoreDim::updateTime()
{
    switch (id)
    {
        case 0 : urlUser = "https://onlineradiobox.com/by/novoeradio/playlist/"; break;
        case 1 : urlUser = "https://onlineradiobox.com/by/unistar/playlist/"; break;
        case 2 : urlUser = "https://onlineradiobox.com/by/rusradio/playlist/"; break;
        //4
        case 3 : urlUser = "https://onlineradiobox.com/by/energyfm/playlist/"; break;
        case 5 : urlUser = "https://onlineradiobox.com/by/melodiiveka/playlist/"; break;
        case 6 : urlUser = "https://onlineradiobox.com/by/radiorelax/playlist/"; break;
        case 7 : urlUser = "https://onlineradiobox.com/by/dushevnoeradio/playlist/"; break;
        case 8 : urlUser = "https://onlineradiobox.com/by/radiys/playlist/"; break;
        case 9 : urlUser = "https://onlineradiobox.com/by/radioba/playlist/"; break;
        case 10 : urlUser = "https://onlineradiobox.com/by/legendy/playlist/"; break;
        case 11 : urlUser = "https://onlineradiobox.com/by/wgfm/playlist/"; break;
        case 12 : urlUser = "https://onlineradiobox.com/by/avtoradio/playlist/"; break;
        case 13 : urlUser = "https://onlineradiobox.com/by/narodnoeradio/playlist/"; break;
        case 14 : urlUser = "https://onlineradiobox.com/by/humorfm/playlist/"; break;
        case 15 : urlUser = "https://onlineradiobox.com/by/v4you/playlist/"; break;
        case 16 : urlUser = "https://onlineradiobox.com/by/pilotfm/playlist/"; break;
        case 17 : urlUser = "https://onlineradiobox.com/by/aplus/playlist/"; break;
        //18
        case 19 : urlUser = "https://onlineradiobox.com/by/s13ru/playlist/"; break;
        case 20 : urlUser = "https://onlineradiobox.com/by/radiobrest/playlist/"; break;
        default:  break;
    }
    work();
    if (id != 4 && id != 18)
    {
        QString path;
        path = song;
        path.replace(" ","%20");
        path.replace("\n","%20-%20");
        path.replace("&","%26");
        path = "https://music.yandex.by/search?text=" + path + "&type=tracks";
        urlUser = path;
        findPic();
    }
}

void AppCoreDim::setNotification(const QString &notification)
{
    if (m_notification == notification)
        return;

    m_notification = notification;
    emit notificationChanged();
}

QString AppCoreDim::notification() const
{
    return m_notification;
}

void AppCoreDim::picReplyFinished()
{
    QString temp = pic1;
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    if (reply->error() == QNetworkReply::NoError)
    {
        QByteArray content= reply->readAll();
        pic1 = content.data();
        QRegExp rgx("(avatars.yandex.net\\/get-music-content.\\w*.\\w*.a.\\w*.\\w*)\\/%");
        rgx.indexIn(pic1);
        pic1 = rgx.cap(1);
        pic1 = "https://" + pic1.left(song.indexOf("/%")) + "/1000x1000";
    }
    if (temp != pic1)
        emit sendToQml_pic(pic1);
    reply->deleteLater();
}

void AppCoreDim::updateAndroidNotification()
{
    QAndroidJniObject javaNotification = QAndroidJniObject::fromString(m_notification);
    QAndroidJniObject::callStaticMethod<void>(
        "org/soldimge/novoeradio/NotificationClient",
        "notify",
        "(Landroid/content/Context;Ljava/lang/String;)V",
        QtAndroid::androidContext().object(),
        javaNotification.object<jstring>());
}

void AppCoreDim::cancel()
{
    QAndroidJniObject::callStaticMethod<void>("org/soldimge/novoeradio/NotificationClient", "cancel");
}

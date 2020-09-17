#include "appcoredim.h"

AppCoreDim::AppCoreDim(QObject *parent) : QObject(parent),
                                          manager(new QNetworkAccessManager(this)),
                                          tmr(new QTimer()),
                                          id(1)
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

void AppCoreDim::but_click(short i)
{
    id = i;
    //    emit sendToQml_ID(id);
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
      QString song = content.data();

      QRegExp rgx("</span></td>\\s*.*class=\"ajax\">(.*)</a></td>");
      rgx.indexIn(song);
      song = rgx.cap(1);
      if (song == "")
      {
          QRegExp rgx("<td>(.*)</td>");
          rgx.indexIn(song);
          song = rgx.cap(1);
      }
      song.replace("&amp;","&");
      song.replace("&#39;","`");
      song.replace(" - ","\n");
      song = song.left(song.indexOf("</a></td>"));
      song = song.left(song.indexOf("["));
      switch (song_num)
      {
        case 1 : song1 = song; break;
        case 2 : song2 = song; break;
        case 4 : song4 = song; break;
      }
  if (song_num == 1)
  {
      emit sendToQml(song1, song2, song4);
      urlUser = "https://onlineradiobox.com/by/novoeradiotop100/playlist/?cs=by.novoeradiotop100";
      song_num = 2;
      work();
  }
  else if (song_num == 2)
  {
      emit sendToQml(song1, song2, song4);
      urlUser = "https://onlineradiobox.com/by/novoeradiofresh/playlist/?cs=by.novoeradiofresh&played=1";
      song_num = 4;
      work();
  }
  else if (song_num == 4)
  {
      emit sendToQml(song1, song2, song4);
      QString temp = m_notification;
      switch (id)
      {
        case 1 : m_notification = song1; break;
        case 2 : m_notification = song2; break;
        case 3 : m_notification = "MegaMix"; break;
        case 4 : m_notification = song4; break;
        case 5 : m_notification = "Wake up show"; break;
      }
      m_notification.replace("<b>","");
      m_notification.replace("</b>","");
      if (temp != m_notification)
          emit notificationChanged();
  }
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
    song_num = 1;
    urlUser = "https://onlineradiobox.com/by/novoeradio/playlist/?cs=by.novoeradio&played=1";
    work();
    if (id != 3 && id != 5)
    {
        QString path;
        if (id == 1)
            path = song1;
        else if (id == 2)
            path = song2;
        else if (id == 4)
            path = song4;
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
        pic1 = "https://" + pic1.left(song1.indexOf("/%")) + "/1000x1000";
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

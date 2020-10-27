#include "appcoredim.h"

AppCoreDim::AppCoreDim(QObject *parent) : QObject(parent),
                                          manager(new QNetworkAccessManager(this)),
                                          tmr(new QTimer()),
                                          homepage{"https://www.novoeradio.by/"},
                                          id(0)
{
    tmr->setInterval(3000);
    connect(tmr, SIGNAL(timeout()), this, SLOT(updateTime()));
    updateTime();
    tmr->start();
}

AppCoreDim::~AppCoreDim()
{
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

void AppCoreDim::homePage()
{
    QNetworkRequest request(homepage);
    QNetworkReply *myReply = manager->get(request);
    connect(myReply, &QNetworkReply::finished, this, &AppCoreDim::HPReplyFinished);
}

void AppCoreDim::HPReplyFinished()
{
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    if (reply->error() == QNetworkReply::NoError)
    {
        QByteArray content = reply->readAll();
        homepage = content.data();
        QString radioLogo{homepage};

        QRegExp rgx("<li><a href=\"(htt.*)\" target");
        rgx.indexIn(homepage);
        homepage = rgx.cap(1);
        homepage = homepage.left(homepage.indexOf("\" target"));

        QRegExp rgx2("<img itemprop=\"image\" src=\"..(.*)\" alt");
        rgx2.indexIn(radioLogo);
        radioLogo = "http://" + rgx2.cap(1);
        radioLogo = radioLogo.left(radioLogo.indexOf("\" alt"));

        emit sendToQml_homePage(homepage, radioLogo);
        qDebug() << "homepage " << homepage;
        qDebug() << "radioLogo " << radioLogo;
    }
    reply->deleteLater();
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

//      qDebug() << "индекс rgx1" << song.indexOf(rgx1, 0) << "индекс rgx2" << song.indexOf(rgx2, 0);

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

      QString temp = m_notification;
      switch (id)
      {
        case 4 : m_notification = "Радио РОКС"; break;
//        case 18 : m_notification = "Центр FM"; break;
        default: m_notification = song; break;
      }
      m_notification.replace("<b>","");
      m_notification.replace("</b>","");
      if (temp != m_notification && song.length() < 100)
      {
          emit sendToQml(song);
          if (id != 4 && id != 18)
          {
              QString path;
              path = song;
              path.replace(" ","%20");
              path.replace("\n","%20-%20");
              path.replace("&","%26");
              path = "https://music.yandex.by/search?text=" + path + "&type=tracks";
              urlUser = path;
              if (pic1 != path)
              {
                  findPic();
                  homePage();
              }
          }
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
    switch (id)
    {
        case 0 : homepage = "https://onlineradiobox.com/by/novoeradio/"; break;
        case 1 : homepage = "https://onlineradiobox.com/by/unistar/"; break;
        case 2 : homepage = "https://onlineradiobox.com/by/rusradio/"; break;
        //4
        case 3 : homepage = "https://onlineradiobox.com/by/energyfm/"; break;
        case 5 : homepage = "https://onlineradiobox.com/by/melodiiveka/"; break;
        case 6 : homepage = "https://onlineradiobox.com/by/radiorelax/"; break;
        case 7 : homepage = "https://onlineradiobox.com/by/dushevnoeradio/"; break;
        case 8 : homepage = "https://onlineradiobox.com/by/radiys/"; break;
        case 9 : homepage = "https://onlineradiobox.com/by/radioba/"; break;
        case 10 : homepage = "https://onlineradiobox.com/by/legendy/"; break;
        case 11 : homepage = "https://onlineradiobox.com/by/wgfm/"; break;
        case 12 : homepage = "https://onlineradiobox.com/by/avtoradio/"; break;
        case 13 : homepage = "https://onlineradiobox.com/by/narodnoeradio/"; break;
        case 14 : homepage = "https://onlineradiobox.com/by/humorfm/"; break;
        case 15 : homepage = "https://onlineradiobox.com/by/v4you/"; break;
        case 16 : homepage = "https://onlineradiobox.com/by/pilotfm/"; break;
        case 17 : homepage = "https://onlineradiobox.com/by/aplus/"; break;
        //18
        case 19 : homepage = "https://onlineradiobox.com/by/s13ru/"; break;
        case 20 : homepage = "https://onlineradiobox.com/by/radiobrest/"; break;
        default:  break;
    }
    urlUser = homepage + "playlist/";
    work();
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

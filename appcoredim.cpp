#include "appcoredim.h"

bool AppCoreDim::_mediaRegistered = false;
//bool AppCoreDim::_isPlaying = false;
AppCoreDim* AppCoreDim::ptr = nullptr;

AppCoreDim::AppCoreDim(QObject *parent) : QObject(parent),
                                          _manager(new QNetworkAccessManager(this)),
                                          _tmr(new QTimer()),
                                          _homepage{"https://www.novoeradio.by/"}
{    
    ptr = this;
    JNINativeMethod methods[] {{"audioFocusLoss", "()V", reinterpret_cast<void *>(audioFocusLoss)},
                               {"audioFocusGain", "()V", reinterpret_cast<void *>(audioFocusGain)}};

    QAndroidJniObject javaClass("org/soldimge/radiod/AndroidSDG");
    QAndroidJniEnvironment env;

    jclass objectClass = env->GetObjectClass(javaClass.object<jobject>());
    env->RegisterNatives(objectClass,
                         methods,
                         sizeof(methods) / sizeof(methods[0]));
    env->DeleteLocalRef(objectClass);

    _id = _settings.value("id").toInt();

    _tmr->setInterval(3000);
    connect(_tmr, SIGNAL(timeout()), this, SLOT(updateTime()));
    updateTime();
    _tmr->start();
}

AppCoreDim::~AppCoreDim()
{
    _settings.setValue("id", _id);
    _settings.sync();
    delete _manager;
    delete _tmr;
}

void AppCoreDim::but_click(qint16 i)
{
    _id = i;
    if(!_mediaRegistered)
    {
        QAndroidJniObject::callStaticMethod<void>("org/soldimge/radiod/AndroidSDG", "registerMediaReceiver");
        _mediaRegistered = true;
        qDebug() << "|||||JAVA : _mediaRegistered = true|||||";
    }
//    QAndroidJniObject::callStaticMethod<void>("org/soldimge/radiod/AndroidSDG", "show");
}

void AppCoreDim::retry()
{
    _tmr->start();
}

void AppCoreDim::homePage()
{
    QNetworkRequest request(_homepage);
    QNetworkReply *myReply = _manager->get(request);
    connect(myReply, &QNetworkReply::finished, this, &AppCoreDim::HPReplyFinished);
}

void AppCoreDim::audioFocusLoss(JNIEnv *env, jobject thiz)
{
    Q_UNUSED(env)
    Q_UNUSED(thiz)
    qDebug() << "||JAVA : AUDIOFOCUS_LOSS";
    _mediaRegistered = false;
    ptr->emitStop();
}

void AppCoreDim::audioFocusGain(JNIEnv *env, jobject thiz)
{
    Q_UNUSED(env)
    Q_UNUSED(thiz)
    qDebug() << "||JAVA : AUDIOFOCUS_GAIN";
    _mediaRegistered = true;
    ptr->emitPlay();
}

void AppCoreDim::HPReplyFinished()
{
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    if (reply->error() == QNetworkReply::NoError)
    {
        QByteArray content = reply->readAll();
        _homepage = content.data();
        QString radioLogo{_homepage};

        QRegExp rgx("<li><a href=\"(htt.*)\" target");
        rgx.indexIn(_homepage);
        _homepage = rgx.cap(1);
        _homepage = _homepage.left(_homepage.indexOf("\" target"));

        QRegExp rgx2("<img itemprop=\"image\" src=\"..(.*)\" alt");
        rgx2.indexIn(radioLogo);
        radioLogo = "http://" + rgx2.cap(1);
        radioLogo = radioLogo.left(radioLogo.indexOf("\" alt"));

        emit sendToQml_homePage(_homepage, radioLogo);
        qDebug() << "homepage " << _homepage;
        qDebug() << "radioLogo " << radioLogo;
    }
    reply->deleteLater();
}

void AppCoreDim::findPic()
{
    QNetworkRequest request(_urlUser);
    QNetworkReply *myReply = _manager->get(request);
    connect(myReply, &QNetworkReply::finished, this, &AppCoreDim::picReplyFinished);
}

void AppCoreDim::work()
{
    QNetworkRequest request(_urlUser);
    QNetworkReply *myReply = _manager->get(request);
    connect(myReply, &QNetworkReply::finished, this, &AppCoreDim::replyFinished);
}

void AppCoreDim::replyFinished()
{
  QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
  if (reply->error() == QNetworkReply::NoError)
  {
      QByteArray content= reply->readAll();
      _song = content.data();

      QRegExp rgx1("</span></td>\\s*.*class=\"ajax\">(.*)</a></td>");
      QRegExp rgx2("<td>(\\w.*)<");

//      qDebug() << "индекс rgx1" << song.indexOf(rgx1, 0) << "индекс rgx2" << song.indexOf(rgx2, 0);

      if (_song.indexOf(rgx1, 0) < _song.indexOf(rgx2, 0) && _song.indexOf(rgx1, 0)!= -1)
      {
          rgx1.indexIn(_song);
          _song = rgx1.cap(1);
          _song = _song.left(_song.indexOf("</a></td>"));
      }
      else
      {
          rgx2.indexIn(_song);
          _song = rgx2.cap(1);
          _song = _song.left(_song.indexOf("</td>"));
      }

      _song.replace("&amp;", "&");
      _song.replace("&#34", "'");
      _song.replace("&#39;", "`");
      _song.replace(" - ", "\n");
      _song.replace(";", "&");
      _song = _song.left(_song.indexOf("["));

      QString temp = _mNotification;
      switch (_id)
      {
        case 4 : _mNotification = "Радио РОКС"; break;
//        case 18 : m_notification = "Центр FM"; break;
        default: _mNotification = _song; break;
      }
      _mNotification.replace("<b>","");
      _mNotification.replace("</b>","");
      static bool synq = true;
      if (synq)
      {
          emit sendSettings(_id);
          synq = false;
      }
      if (temp != _mNotification && _song.length() < 100)
      {
          emit sendToQml(_song);
          if (_id != 4 && _id != 18)
          {
              QString path;
              path = _song;
              path.replace(" ","%20");
              path.replace("\n","%20-%20");
              path.replace("&","%26");
              path = "https://music.yandex.by/search?text=" + path + "&type=tracks";
              _urlUser = path;
              if (_pic1 != path)
              {
                  findPic();
                  homePage();
              }
          }
      }
  }
  else
  {
      qDebug() << reply->errorString();
      _tmr->stop();
      emit netError();
  }
  reply->deleteLater();
}

void AppCoreDim::updateTime()
{
    switch (_id)
    {
        case 0 : _homepage = "https://onlineradiobox.com/by/novoeradio/"; break;
        case 1 : _homepage = "https://onlineradiobox.com/by/unistar/"; break;
        case 2 : _homepage = "https://onlineradiobox.com/by/rusradio/"; break;
        //4
        case 3 : _homepage = "https://onlineradiobox.com/by/energyfm/"; break;
        case 5 : _homepage = "https://onlineradiobox.com/by/melodiiveka/"; break;
        case 6 : _homepage = "https://onlineradiobox.com/by/radiorelax/"; break;
        case 7 : _homepage = "https://onlineradiobox.com/by/dushevnoeradio/"; break;
        case 8 : _homepage = "https://onlineradiobox.com/by/radiys/"; break;
        case 9 : _homepage = "https://onlineradiobox.com/by/radioba/"; break;
        case 10 : _homepage = "https://onlineradiobox.com/by/legendy/"; break;
        case 11 : _homepage = "https://onlineradiobox.com/by/wgfm/"; break;
        case 12 : _homepage = "https://onlineradiobox.com/by/avtoradio/"; break;
        case 13 : _homepage = "https://onlineradiobox.com/by/narodnoeradio/"; break;
        case 14 : _homepage = "https://onlineradiobox.com/by/humorfm/"; break;
        case 15 : _homepage = "https://onlineradiobox.com/by/v4you/"; break;
        case 16 : _homepage = "https://onlineradiobox.com/by/pilotfm/"; break;
        case 17 : _homepage = "https://onlineradiobox.com/by/aplus/"; break;
        //18
        case 19 : _homepage = "https://onlineradiobox.com/by/s13ru/"; break;
        case 20 : _homepage = "https://onlineradiobox.com/by/radiobrest/"; break;
        default:  break;
    }
    _urlUser = _homepage + "playlist/";
    work();
}

void AppCoreDim::picReplyFinished()
{
    QString temp = _pic1;
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    if (reply->error() == QNetworkReply::NoError)
    {
        QByteArray content= reply->readAll();
        _pic1 = content.data();
        QRegExp rgx("(avatars.yandex.net\\/get-music-content.\\w*.\\w*.a.\\w*.\\w*)\\/%");
        rgx.indexIn(_pic1);
        _pic1 = rgx.cap(1);
        _pic1 = "https://" + _pic1.left(_song.indexOf("/%")) + "/1000x1000";
    }
    if (temp != _pic1)
        emit sendToQml_pic(_pic1);
    reply->deleteLater();
}

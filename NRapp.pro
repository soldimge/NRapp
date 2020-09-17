QT += qml quick webview network androidextras

CONFIG += c++17

DEFINES += QT_DEPRECATED_WARNINGS

SOURCES += main.cpp \
    appcoredim.cpp

RESOURCES += qml.qrc

DISTFILES += \
    android/AndroidManifest.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew \
    android/gradlew.bat \
    android/src/org/qtproject/example/notification/NotificationClient.java \
    android/res/values/libs.xml

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

android: include(C:/Users/by01.user/AppData/Local/Android/Sdk/android_openssl/openssl.pri)

HEADERS += \
    appcoredim.h

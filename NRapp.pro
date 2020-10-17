QT += qml quick webview network androidextras

CONFIG += c++17

DEFINES += \
    QT_DEPRECATED_WARNINGS \
    QTAT_ADMOB_BANNER

SOURCES += main.cpp \
    appcoredim.cpp

RESOURCES += qml.qrc

DISTFILES += \
    android/AndroidManifest.xml \
    android/build.gradle \
    android/gradle.properties \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew \
    android/gradlew.bat \
    android/src/org/qtproject/example/notification/NotificationClient.java \
    android/res/values/libs.xml

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

android {
include(C:/Users/by01.user/AppData/Local/Android/Sdk/android_openssl/openssl.pri)
include(../QtAndroidTools/QtAndroidTools.pri)
}

HEADERS += \
    appcoredim.h

ANDROID_ABIS = armeabi-v7a arm64-v8a

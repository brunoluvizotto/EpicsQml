QT += qml quick

android {
    message("* Using settings for Android.")
    QT += androidextras
    SOURCES += notificationclient.cpp mainandroid.cpp
    HEADERS += notificationclient.h
}
linux:!android {
    message("* Using settings for Unix/Linux.")
    SOURCES += main.cpp
}

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android-sources

CONFIG += c++11

OTHER_FILES += \
    android-sources/src/org/qtproject/example/notification/NotificationClient.java \
    android-sources/AndroidManifest.xml

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

DISTFILES += \
    android-sources/gradle/wrapper/gradle-wrapper.jar \
    android-sources/gradlew \
    android-sources/res/values/libs.xml \
    android-sources/build.gradle \
    android-sources/gradle/wrapper/gradle-wrapper.properties \
    android-sources/gradlew.bat

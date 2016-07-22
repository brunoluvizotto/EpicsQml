import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

Item {
    id: rootRoku
    anchors.fill: parent

    property real buttonHeight: height * 0.1

    Button {
        id: powerButton
        height: buttonHeight
        width: height
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.02
        anchors.horizontalCenter: parent.horizontalCenter

        visible: true
        onClicked:
        {
            socket.sendTextMessage(JSON.stringify({ "action":"setpv", "pv":"UBU{Roku:Power}OUT" , "value":1}))
        }

        Image {
            source: "qrc:/png/power.png"
            height: parent.height * 0.5
            width: height
            anchors.centerIn: parent
        }
    }

    Row {
        id: rowBack
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: powerButton.bottom
        anchors.topMargin: parent.height * 0.02
        spacing: rootRoku.height * 0.02

        Button {
            height: buttonHeight
            width: height
            anchors.verticalCenter: parent.verticalCenter

            visible: true
            onClicked:
            {
                socket.sendTextMessage(JSON.stringify({ "action":"setpv", "pv":"UBU{Roku:Back}OUT" , "value":1}))
            }

            Image {
                source: "qrc:/png/left-arrow.png"
                height: parent.height * 0.5
                width: height
                anchors.centerIn: parent
            }
        }
        Button {
            height: buttonHeight
            width: height

            visible: true
            onClicked:
            {
                socket.sendTextMessage(JSON.stringify({ "action":"setpv", "pv":"UBU{Roku:Home}OUT" , "value":1}))
            }

            Image {
                source: "qrc:/png/home.png"
                height: parent.height * 0.5
                width: height
                anchors.centerIn: parent
            }
        }
    }

    Column {
        id: columnArrows
        anchors.top: rowBack.bottom
        anchors.topMargin: parent.height * 0.02
        anchors.horizontalCenter: parent.horizontalCenter
        //spacing: parent.height * 0.02

        Button {
            height: buttonHeight
            width: height
            anchors.horizontalCenter: parent.horizontalCenter

            visible: true
            onClicked:
            {
                socket.sendTextMessage(JSON.stringify({ "action":"setpv", "pv":"UBU{Roku:Up}OUT" , "value":1}))
            }

            Image {
                source: "qrc:/png/up-arrow.png"
                height: parent.height * 0.5
                width: height
                anchors.centerIn: parent
            }
        }
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: rootRoku.height * 0.02

            Button {
                height: buttonHeight
                width: height
                anchors.verticalCenter: parent.verticalCenter

                visible: true
                onClicked:
                {
                    socket.sendTextMessage(JSON.stringify({ "action":"setpv", "pv":"UBU{Roku:Left}OUT" , "value":1}))
                }

                Image {
                    source: "qrc:/png/left-arrow-1.png"
                    height: parent.height * 0.5
                    width: height
                    anchors.centerIn: parent
                }
            }
            Button {
                height: buttonHeight
                width: height
                text: "OK"

                visible: true
                onClicked:
                {
                    socket.sendTextMessage(JSON.stringify({ "action":"setpv", "pv":"UBU{Roku:Select}OUT" , "value":1}))
                }
            }
            Button {
                height: buttonHeight
                width: height

                visible: true
                onClicked:
                {
                    socket.sendTextMessage(JSON.stringify({ "action":"setpv", "pv":"UBU{Roku:Right}OUT" , "value":1}))
                }

                Image {
                    source: "qrc:/png/right-arrow.png"
                    height: parent.height * 0.5
                    width: height
                    anchors.centerIn: parent
                }
            }
        }
        Button {
            height: buttonHeight
            width: height
            anchors.horizontalCenter: parent.horizontalCenter

            visible: true
            onClicked:
            {
                socket.sendTextMessage(JSON.stringify({ "action":"setpv", "pv":"UBU{Roku:Down}OUT" , "value":1}))
            }

            Image {
                source: "qrc:/png/down-arrow.png"
                height: parent.height * 0.5
                width: height
                anchors.centerIn: parent
            }
        }
    }

    Row {
        id: rowInstantReplay
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: columnArrows.bottom
        anchors.topMargin: parent.height * 0.02
        spacing: rootRoku.height * 0.02

        Button {
            height: buttonHeight
            width: height
            anchors.verticalCenter: parent.verticalCenter

            visible: true
            onClicked:
            {
                socket.sendTextMessage(JSON.stringify({ "action":"setpv", "pv":"UBU{Roku:InstantReplay}OUT" , "value":1}))
            }

            Image {
                source: "qrc:/png/arrows.png"
                height: parent.height * 0.5
                width: height
                anchors.centerIn: parent
            }
        }
        Button {
            height: buttonHeight
            width: height

            visible: true
            onClicked:
            {
                socket.sendTextMessage(JSON.stringify({ "action":"setpv", "pv":"UBU{Roku:Info}OUT" , "value":1}))
            }

            Image {
                source: "qrc:/png/miscellaneus.png"
                height: parent.height * 0.5
                width: height
                anchors.centerIn: parent
            }
        }
    }

    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: rowInstantReplay.bottom
        anchors.topMargin: parent.height * 0.02
        spacing: rootRoku.height * 0.02

        Button {
            height: buttonHeight
            width: height
            anchors.verticalCenter: parent.verticalCenter

            visible: true
            onClicked:
            {
                socket.sendTextMessage(JSON.stringify({ "action":"setpv", "pv":"UBU{Roku:Rev}OUT" , "value":1}))
            }

            Image {
                source: "qrc:/png/remote-control-fast-back-button.png"
                height: parent.height * 0.5
                width: height
                anchors.centerIn: parent
            }
        }
        Button {
            height: buttonHeight
            width: height

            visible: true
            onClicked:
            {
                socket.sendTextMessage(JSON.stringify({ "action":"setpv", "pv":"UBU{Roku:Play}OUT" , "value":1}))
            }

            Image {
                source: "qrc:/png/shapes.png"
                height: parent.height * 0.5
                width: height
                anchors.centerIn: parent
            }
        }
        Button {
            height: buttonHeight
            width: height

            visible: true
            onClicked:
            {
                socket.sendTextMessage(JSON.stringify({ "action":"setpv", "pv":"UBU{Roku:Fwd}OUT" , "value":1}))
            }

            Image {
                source: "qrc:/png/remote-control-fast-forward-button.png"
                height: parent.height * 0.5
                width: height
                anchors.centerIn: parent
            }
        }
    }

    Column {
        id: columnVolume
        anchors.top: rowBack.top
        anchors.right: parent.right
        anchors.rightMargin: parent.height * 0.02
        Button {
            id: volumeUpButton
            height: buttonHeight
            width: height * 0.75

            visible: true
            onClicked:
            {
                socket.sendTextMessage(JSON.stringify({ "action":"setpv", "pv":"UBU{Roku:VolumeUp}OUT" , "value":1}))
            }

            Image {
                source: "qrc:/png/volume-up-interface-symbol.png"
                height: parent.height * 0.5
                width: height
                anchors.centerIn: parent
            }
        }
        Button {
            height: buttonHeight
            width: height * 0.75

            visible: true
            onClicked:
            {
                socket.sendTextMessage(JSON.stringify({ "action":"setpv", "pv":"UBU{Roku:VolumeDown}OUT" , "value":1}))
            }

            Image {
                source: "qrc:/png/volume-down-interface-symbol.png"
                height: parent.height * 0.5
                width: height
                anchors.centerIn: parent
            }
        }
        Button {
            height: buttonHeight
            width: height * 0.75

            visible: true
            onClicked:
            {
                socket.sendTextMessage(JSON.stringify({ "action":"setpv", "pv":"UBU{Roku:VolumeMute}OUT" , "value":1}))
            }

            Image {
                source: "qrc:/png/volume-mute-interface-symbol.png"
                height: parent.height * 0.5
                width: height
                anchors.centerIn: parent
            }
        }
    }
}

import QtQuick 2.6
import QtQuick.Window 2.2

Window {
    id: root
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")
    color: Qt.rgba(1,1,1,1)
    property int xRotVal: Math.floor(Math.random()*360)
    property int yRotVal: Math.floor(Math.random()*360)
    property int zRotVal: Math.floor(Math.random()*360)
    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(1,1,1,1)
        focus: true
        Image {
            id: ball
            x: 10
            y: 10
            width: 200
            height: 200
            source: "/Users/jiahao/Documents/logo.png"
            transform:
            [
                Rotation {id:yRotation; origin.x: 30; origin.y: 30; axis { x: 0; y: 1; z: 0 } angle: yRotVal },
                Rotation {id:xRotation; origin.x: 30; origin.y: 30; axis { x: 1; y: 0; z: 0 } angle: xRotVal },
                Rotation {id:zRotation; origin.x: 30; origin.y: 30; axis { x: 0; y: 0; z: 1 } angle: zRotVal }
            ]
            smooth: true
        }

        Canvas {
            id: canvas
            anchors.fill: parent
            property int prevX
            property int prevY
            property int lineWidth: 3
            property color drawColor: "black"

            MouseArea {
                id:mousearea
                anchors.fill: parent
                onPressed: {
                    canvas.prevX = mouseX;
                    canvas.prevY = mouseY;
                    console.log("press!!");
                }
                onPositionChanged: {
                    canvas.requestPaint();

                }
            }

            onPaint: {
                var ctx = getContext('2d');
                ctx.beginPath();
                ctx.strokeStyle = drawColor
                ctx.lineWidth = lineWidth
                console.log("prev: "+"("+prevX, ",", prevY,")")
                ctx.moveTo(prevX, prevY);
                console.log("mouse: " + "("+mousearea.mouseX, ",", mousearea.mouseY,")")
                ctx.lineTo(mousearea.mouseX, mousearea.mouseY);
                ctx.stroke();
                ctx.closePath();
                prevX = mousearea.mouseX;
                prevY = mousearea.mouseY;
            }
        }

        Text {
            id: countDownText
            anchors.centerIn: parent
//            width: parent.width/2
//            height: parent.height/2
            font.pixelSize: parent.height/5
            visible: false
        }

        Timer {
            id: countDownTimer
            interval: 100; running: countDownText.visible; repeat: true
            property var startTime: new Date()
            property var timeCount
            // count down timer
            onTriggered: {
                var d = new Date();
                timeCount = Math.floor((d.getTime() - startTime.getTime()) / 1000);
                var curr = 5 - timeCount;
                if (curr == -1) {
                    countDownText.visible = false;
                }
                countDownText.text = curr;
            }
            onRunningChanged: {
                startTime = new Date();
                if (!running)
                    countDownText.text = 0;
            }
        }

        Text {
            id: timeClockText
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
//            width:
//            height: parent.height/10
            font.pixelSize: parent.height/5
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            visible: false
        }

        Timer {
            id: timeClockTimer
            interval: 100; running: timeClockText.visible; repeat: true
            property var startTime: new Date()
            property var timeCount
            onTriggered: {
                var d = new Date();
                timeCount = Math.floor((d.getTime() - startTime.getTime()) / 1000);
                var h = Math.floor(timeCount / 3600);
                timeCount %= 3600;
                var m = Math.floor(timeCount / 60);
                timeCount %= 60;
                var s = timeCount % 60;
                var hstr = ("0"+h).substr(-2)
                var mstr = ("0"+m).substr(-2)
                var sstr = ("0"+s).substr(-2)
                timeClockText.text = hstr+":"+mstr+":"+sstr;
            }
            onRunningChanged: {
                startTime = new Date();
                if (!running)
                    timeClockText.text = "00:00:00";
            }
        }

        Timer {
            interval: 1000; running: true; repeat: true
            onTriggered: {
                ball.x = Math.floor((Math.random() * root.width-ball.width) + 1);
                ball.y = Math.floor((Math.random() * root.height-ball.height) + 1);
//                ball.xRotation.angle = Math.floor(Math.random()*360);
//                ball.transform.yRotation.angle = Math.floor(Math.random()*360);
//                ball.transform.zRotation.angle = Math.floor(Math.random()*360);
//                ball.xRoation.origin.x = 10;
                xRotVal = Math.floor(Math.random()*360);
                yRotVal = Math.floor(Math.random()*360);
                zRotVal = Math.floor(Math.random()*360);
            }
        }



        Keys.onPressed: {
            switch(event.key) {
            case Qt.Key_Space:
                timeClockText.visible = !timeClockText.visible
                break;
            case Qt.Key_S:
                countDownText.visible = !countDownText.visible
            }
        }
    }
}

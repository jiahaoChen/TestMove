#include <QApplication>
#include <QtNetwork>

class CClient
    : public QObject
{
    Q_OBJECT
public:
    CClient()
        : m_socket(NULL)
    {
        m_socket = new QLocalSocket();

        QObject::connect(m_socket, SIGNAL(connected()), this, SLOT(socketConnectedHandler()));
        QObject::connect(m_socket, SIGNAL(disconnected()), this, SLOT(socketDisConnectedHandler()));
        QObject::connect(m_socket, SIGNAL(error(QLocalSocket::LocalSocketError)), this, SLOT(socketErrorHandler(QLocalSocket::LocalSocketError)));
        QObject::connect(m_socket, SIGNAL(readyRead()), this, SLOT(readyReadHandler()));
    }

    ~CClient()
    {
        m_socket->disconnectFromServer();

        delete m_socket;
    }

public:
    void ConnectToServer(const QString &strServerName)
    {
        // 服务端的serverNewConnectionHandler成员方法将被调用
        m_socket->connectToServer("ServerName");
        if (m_socket->waitForConnected())
        {
            // TODO:
        }
    }

    void sendMessage(const QString &msg)
    {
        m_socket->write(msg.toUtf8());
        m_socket->flush();

        // waitForReadyRead将激发信号readyRead()， 我们在
        // 与服务端创建连接时，已将readyRead()，绑定到了服务
        // 端的槽socketReadyReadHandler成员方法
        if (!m_socket->bytesAvailable())
            m_socket->waitForReadyRead();

        QTextStream stream(m_socket);
        QString respond = stream.readLine();

        qDebug() << "Read Data From Server:" << respond;
    }

private slots:
    void socketConnectedHandler()
    {
        qDebug() << "connected.";
    }

    void socketDisConnectedHandler()
    {
        qDebug() << "disconnected.";
    }

    void socketErrorHandler(QLocalSocket::LocalSocketError error)
    {
        qWarning() << error;
    }
    void readyReadHandler()
    {
        QTextStream stream(m_socket);
        QString respond = stream.readLine();
        qDebug() << "Read Data From Server:" << respond;
    }

private:
    QLocalSocket *m_socket;
};

int main(int argc, char *argv[])
{
    // 至qt4.8（以上的不知道），在window下QApplication
    // 必需放到QLocalServer创建之前
    // 参考地址：http://www.qtcentre.org/archive/index.php/t-43522.html?s=26444975027844d43142ce2238f4605e
    QApplication app(argc, argv);

    CClient client;
    client.ConnectToServer("ServerName");
//    while (1)
        client.sendMessage("Hellow Server\n");

    return app.exec();
}

#include "main.moc"

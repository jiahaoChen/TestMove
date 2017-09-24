#include <QApplication>
#include <QtNetwork>

class CServer
    : public QObject
{
    Q_OBJECT
public:
    CServer()
        : m_server(NULL)
    {
        m_server = new QLocalServer(this);
        QObject::connect(m_server, SIGNAL(newConnection()), this, SLOT(serverNewConnectionHandler()));
    }

    ~CServer()
    {
        m_server->close();

        delete m_server;
    }

    void RunServer()
    {
        qDebug() << "Run Server ok";

        QLocalServer::removeServer("ServerName");
        bool ok = m_server->listen("ServerName");
        if (!ok)
        {
            // TODO:
        }
    }

private slots:
    void serverNewConnectionHandler()
    {
        qDebug() << "New Connection";

        QLocalSocket* socket = m_server->nextPendingConnection();
        QObject::connect(socket, SIGNAL(readyRead()), this, SLOT(socketReadyReadHandler()));
        QObject::connect(socket, SIGNAL(disconnected()), socket, SLOT(deleteLater()));
//        QObject::connect(m_server, SIGNAL(newConnection()), this, SLOT(newConnectionHandler()));
    }

    void newConnectionHandler()
    {
        QLocalSocket* socket = static_cast<QLocalSocket*>(sender());
        if (socket)
        {
            QTextStream stream(socket);
            qDebug() << "Read Data From Client:" << stream.readLine();
            while (1) {
                QString response = "Hello Client\n";
                socket->write(response.toUtf8());
                socket->flush();
            }
        }
    }
    void socketReadyReadHandler()
    {
        QLocalSocket* socket = static_cast<QLocalSocket*>(sender());
        if (socket)
        {
            QTextStream stream(socket);
            qDebug() << "Read Data From Client:" << stream.readLine();

            while (1) {
                QString response = "Hello Client\n";
                socket->write(response.toUtf8());
                socket->flush();
            }
        }

        // 返回到客户端的void sendMessage方法，m_socket->waitForReadyRead()之后的操作
    }

private:
    QLocalServer *m_server;
};

int main(int argc, char *argv[])
{
    // 至qt4.8（以上的不知道），在window下QApplication
    // 必需放到QLocalServer创建之前
    // 参考地址：http://www.qtcentre.org/archive/index.php/t-43522.html?s=26444975027844d43142ce2238f4605e
    QApplication app(argc, argv);

    CServer server;
    server.RunServer();

    return app.exec();
}

#include "main.moc"

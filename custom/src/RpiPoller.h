#pragma once

#include <QtCore/QObject>
#include <QtCore/QTimer>
#include <QtCore/QVariantMap>
#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkReply>

class RpiPoller : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool      online READ online NOTIFY onlineChanged)
    Q_PROPERTY(QVariantMap data READ data   NOTIFY dataChanged)

public:
    explicit RpiPoller(QObject *parent = nullptr);

    bool       online() const { return _online; }
    QVariantMap data()  const { return _data;   }

signals:
    void onlineChanged();
    void dataChanged();

private slots:
    void _poll();
    void _onReply(QNetworkReply *reply);

private:
    QNetworkAccessManager _nam;
    QTimer                _timer;
    bool                  _online         = false;
    bool                  _requestPending = false;
    QVariantMap           _data;
};

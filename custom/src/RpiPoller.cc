#include "RpiPoller.h"

#include <QtCore/QJsonDocument>
#include <QtCore/QJsonObject>
#include <QtNetwork/QNetworkRequest>

static constexpr const char *kRpiUrl   = "http://192.168.10.2:5000/api/datos";
static constexpr int         kPollMs   = 2000;
static constexpr int         kTimeoutMs = 1500;

RpiPoller::RpiPoller(QObject *parent)
    : QObject(parent)
{
    connect(&_nam, &QNetworkAccessManager::finished, this, &RpiPoller::_onReply);
    _timer.setInterval(kPollMs);
    connect(&_timer, &QTimer::timeout, this, &RpiPoller::_poll);
    _timer.start();
    _poll();
}

void RpiPoller::_poll()
{
    if (_requestPending) {
        return;
    }
    _requestPending = true;
    QNetworkRequest req{QUrl(QString::fromLatin1(kRpiUrl))};
    req.setTransferTimeout(kTimeoutMs);
    _nam.get(req);
}

void RpiPoller::_onReply(QNetworkReply *reply)
{
    _requestPending = false;
    reply->deleteLater();

    if (reply->error() != QNetworkReply::NoError) {
        if (_online) {
            _online = false;
            emit onlineChanged();
        }
        return;
    }

    const QJsonDocument doc = QJsonDocument::fromJson(reply->readAll());
    if (!doc.isObject()) {
        if (_online) {
            _online = false;
            emit onlineChanged();
        }
        return;
    }

    _data = doc.object().toVariantMap();
    emit dataChanged();

    if (!_online) {
        _online = true;
        emit onlineChanged();
    }
}

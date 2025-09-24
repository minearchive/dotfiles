import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

      property ListModel notificationModel: ListModel {}

    property NotificationServer server: NotificationServer { 
        id: notificationServer

        // Server capabilities
        keepOnReload: false
        imageSupported: true
        actionsSupported: true
        actionIconsSupported: true
        bodyMarkupSupported: true
        bodySupported: true
        persistenceSupported: true
        inlineReplySupported: true
        bodyHyperlinksSupported: true
        bodyImagesSupported: true

        onNotification: function (notification) {
            console.log("New notification from " + notification.appName + ": " + notification.summary);
        }
    }
}
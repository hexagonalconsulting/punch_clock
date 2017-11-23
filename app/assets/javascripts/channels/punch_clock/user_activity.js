// This meta tag should only be included in the host app `/app/views/layouts/application.html.erb`
// if there is a current_user from devise.
if (document.querySelectorAll('meta[name=action-cable-url]').length) {

    var reportBrowserAsActive;

    App.userActivitySubscription = App.cable.subscriptions.create("PunchClock::UserActivityChannel", {

        connected: function() {
            // Called when the subscription is ready for use on the server
            if ( window.AppInfo.railsEnv === 'development' || window.AppInfo.railsEnv === 'test' ) {
                var userActivitySubscriptionMessage = 'you are subscribed to PunchClock::UserActivityChannel';
                console.log(userActivitySubscriptionMessage);
                document
                    .getElementById('user-activity-subscription-message')
                    .insertAdjacentHTML('beforeend', userActivitySubscriptionMessage );
            }

        },

        disconnected: function() {
            //Called when the subscription has been terminated by the server.
        },

        received: function(data) {
            //Called when there's incoming data on the websocket for this channel.
        },

        report_browser_as_active: function() {
            return this.perform('report_browser_as_active');
        },

        report_browser_as_open: function() {
            return this.perform('report_browser_as_open');
        }

    });

    //!App.userActivitySubscription.consumer.connection.disconnected means that the user is not disconnected (logged out).

    reportBrowserAsActive = function() {

        if (!App.userActivitySubscription.consumer.connection.disconnected) {
            return App.userActivitySubscription.report_browser_as_active();
        }

    };



    document.onclick = function() {
        return reportBrowserAsActive();
    };

    document.onkeypress = function() {
        return reportBrowserAsActive();
    };

    window.onfocus = function() {
        return reportBrowserAsActive();
    };

    var reportInterval =  5000;

    setInterval(function () {
        if (!App.userActivitySubscription.consumer.connection.disconnected) {
            return App.userActivitySubscription.report_browser_as_open();
        }
    }, reportInterval);
}

// This meta tag should only be included in the host app `/app/views/layouts/application.html.erb`
// if there is a current_user from devise.
if (document.querySelectorAll('meta[name=action-cable-url]').length) {

    App.user_activity = App.cable.subscriptions.create("PunchClock::UserActivityChannel", {
        connected: function() {
            // Called when the subscription is ready for use on the server
            console.log('subscribed to PunchClock::UserActivityChannel')
        },

        disconnected: function() {
            // Called when the subscription has been terminated by the server
        },

        received: function(data) {
            // Called when there's incoming data on the websocket for this channel
        }
    });

}

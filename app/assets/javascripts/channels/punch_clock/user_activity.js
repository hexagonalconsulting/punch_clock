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


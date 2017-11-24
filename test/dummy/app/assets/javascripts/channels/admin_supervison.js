if (document.querySelectorAll('meta[name=action-cable-url]').length) {
    var userStatus = 'whatever';
    var  userId = 1;
    App['PunchClock::ActivitySupervisionChannel:userId[' + userId + ']'] = App.cable.subscriptions.create({
        channel: "PunchClock::ActivitySupervisionChannel",
        id: userId}, {
        received: function(userUpdate)  {
            if ( window.AppInfo.railsEnv === 'development' || window.AppInfo.railsEnv === 'test' ) {
                userStatus = userUpdate.status;
                console.log('userStatus:', userStatus);

                var userStatusMessage = 'user with the id: ' + userUpdate.id + ' has the status: ' + userStatus;
                document
                    .getElementById('admin-supervision-user-status')
                    .insertAdjacentHTML('beforeend', userStatusMessage );

            }
        },
        connected: function() {
            // Called when the subscription is ready for use on the server
            if ( window.AppInfo.railsEnv === 'development' || window.AppInfo.railsEnv === 'test' ) {
                var activitySupervisionSubscriptionMessage = 'you are subscribed to PunchClock::ActivitySupervisionChannel';
                console.log(activitySupervisionSubscriptionMessage);
                document
                    .getElementById('admin-supervision-subscription-message')
                    .insertAdjacentHTML('beforeend', activitySupervisionSubscriptionMessage );
            }

        },
        rejected: function() {

            var rejectedMessage = 'you were rejected from the PunchClock::ActivitySupervisionChannel';
            console.log(rejectedMessage);
            document
                .getElementById('admin-supervision-rejected-message')
                .insertAdjacentHTML('beforeend', rejectedMessage );

        }
    });
}
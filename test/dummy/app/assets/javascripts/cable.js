// Action Cable provides the framework to deal with WebSockets in Rails.
// You can generate new channels where WebSocket features live using the `rails generate channel` command.
//
//= require action_cable
//= require_self
//= require_tree ./channels

// This meta tag only is included in dummy/app/views/layouts/application.html.erb if there is a current_user from devise.
if (document.querySelectorAll('meta[name=action-cable-url]').length) {
    (function () {
        this.App || (this.App = {});

        App.cable = ActionCable.createConsumer();

    }).call(this);
}
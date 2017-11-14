# source: http://stackoverflow.com/questions/7178670/testing-activesupportnotifications-with-rspec
def notification_payload_for(notification)
  called = false
  payload = nil

  subscription = ActiveSupport::Notifications.subscribe notification do |name, start, finish, _id, _payload|
    called = true
    payload = _payload
  end

  yield

  ActiveSupport::Notifications.unsubscribe(subscription)

  return called, payload
end
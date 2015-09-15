require 'test_helper'

class NotificationMailerTest < ActionMailer::TestCase
  test "celebrity_notification" do
    mail = NotificationMailer.celebrity_notification
    assert_equal "Celebrity notification", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end

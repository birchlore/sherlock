require 'test_helper'

class NotificationMailerTest < ActionMailer::TestCase
  test "celebrity_notification" do
  	celebrity = build(:celebrity)
    mail = NotificationMailer.celebrity_notification(celebrity)
    assert_equal "Celebrity notification", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end

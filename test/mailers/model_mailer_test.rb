require 'test_helper'

class ModelMailerTest < ActionMailer::TestCase
  test "celebrity_notification" do
    mail = ModelMailer.celebrity_notification
    assert_equal "Celebrity notification", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end

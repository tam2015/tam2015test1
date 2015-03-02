require 'test_helper'

class Mailing::NotifyTest < ActionMailer::TestCase
  test "no_address" do
    mail = Mailing::Notify.no_address
    assert_equal "No address", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end

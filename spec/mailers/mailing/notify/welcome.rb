require "rails_helper"

RSpec.describe Mailing::Notify, :type => :mailer do
  describe "welcome_email" do
    let(:mail) { Mailing::Notify.welcome }

    it "renders the headers" do
      expect(mail.subject ).to eq("Seja bem vindo ao AirCRM")
      expect(mail.to      ).to eq(["to@example.org"])
      expect(mail.from    ).to eq(ENV["MAIL_DEFAULT_FROM"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end

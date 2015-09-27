require 'spec_helper'
require 'shared_examples'

describe Celebrity, :vcr do
  include_context "shared examples"

  it { should belong_to(:shop) }

  it { should respond_to(:shop) }
  it { should respond_to (:first_name)}
  it { should respond_to (:last_name)}
  it { should respond_to (:email)}
  it { should respond_to (:imdb_url)}
  it { should respond_to (:wikipedia_url)}
  it { should respond_to (:twitter_followers)}
  it { should respond_to (:youtube_followers)}
  it { should respond_to (:instagram_followers)}
  it { should respond_to (:industry)}
  it { should respond_to (:imdb_bio)}
  it { should respond_to (:wikipedia_bio)}
  it { should respond_to (:status)}
  it { should respond_to (:shopify_url)}
  it { should respond_to (:created_at)}
  it { should respond_to (:updated_at)}
  it { should respond_to (:twitter_bio)}
  it { should respond_to (:twitter_url)}
  it { should respond_to (:youtube_bio)}
  it { should respond_to (:youtube_url)}
  it { should respond_to (:angellist_bio)}
  it { should respond_to (:angellist_url)}
  it { should respond_to (:linkedin_bio)}
  it { should respond_to (:instagram_id)}
  it { should respond_to (:klout_id)}
  it { should respond_to (:klout_score)}
  it { should respond_to (:klout_url)}

  it { should validate_presence_of (:first_name)}
  it { should validate_presence_of (:last_name)}

  it { should respond_to (:full_name)}
  it { should respond_to (:celebrity?)}
  it { should respond_to (instance_eval{:sanitize})}


  it "has a valid factory" do
    expect(celebrity).to_not be_valid
    expect(twitter_celebrity).to be_valid
    expect(wikipedia_celebrity).to be_valid
    expect(imdb_celebrity).to be_valid
  end


  describe "full_name" do
    it "returns a celebrity's full name as a string" do
      contact = build(:celebrity, first_name: "John", last_name: "Doe", email: "John@gmail.com")
      expect(contact.full_name).to eq("John Doe")
    end
  end


  describe "sanitize" do
    it "converts a celebrity's name to proper capitalization" do
      contact = create(:celebrity, first_name: "JoHN", last_name: "dOE", email: "John@gmail.com")
      expect(contact.full_name).to eq("John Doe")
    end
  end


  describe "send_email_notification" do

    context 'when email notifications are turned on and customer is a celebrity' do
      it 'calls send_email_notification on NotificationMailer' do
        expect(NotificationMailer).to receive(:celebrity_notification).with(an_instance_of(Celebrity)).and_return(double(deliver_now:true))
        create(:wikipedia_celebrity, shop: shop)
      end
    end

    # context 'when email notifications are turned on and customer is not a celebrity' do
    #   it 'does not call send_email_notification' do
    #     expect(NotificationMailer).not_to receive(:celebrity_notification)
    #     expect(create(:celebrity, shop: shop)
    #   end
    # end

    context 'when email notifications are turned off and customer is a celebrity' do
      it 'does not call send_email_notification' do
        expect(NotificationMailer).not_to receive(:celebrity_notification)
        create(:wikipedia_celebrity, shop: shop_without_notifications)
      end
    end

  end

  describe "get_celebrity_status" do
    it "should call GetCelebrityStatus" do
      expect(GetCelebrityStatus).to receive(:call).with(celebrity)
      celebrity.send(:get_celebrity_status)
    end
  end

end
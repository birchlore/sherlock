require 'spec_helper'
require 'shared_examples'


describe Customer, :vcr do

  include_context "shared examples"
  # it { should belong_to(:shop) }

  it { should respond_to(:shop) }
  it { should respond_to (:first_name)}
  it { should respond_to (:last_name)}
  it { should respond_to (:email)}
  it { should respond_to (:imdb_url)}
  it { should respond_to (:wikipedia_url)}
  it { should respond_to (:twitter_followers)}
  it { should respond_to (:youtube_subscribers)}
  it { should respond_to (:instagram_followers)}
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

  # it { should validate_presence_of (:first_name)}
  # it { should validate_presence_of (:last_name)}

  it { should respond_to (:full_name)}
  it { should respond_to (:celebrity?)}


  it "has a valid celebrity factory" do
    expect(customer).to be_valid
  end

   it "has a valid twitter factory" do
    expect(twitter_celebrity).to be_valid
  end

   it "has a valid wikipedia factory" do
    expect(wikipedia_celebrity).to be_valid
  end

  it "has a valid imdb factory" do
    expect(imdb_celebrity).to be_valid
  end
    

  describe "full_name" do
    it "returns a celebrity's full name as a string" do
      contact = build(:customer, first_name: "John", last_name: "Doe", email: "John@gmail.com")
      expect(contact.full_name).to eq("John Doe")
    end
  end


  describe "sanitize" do
    it "converts a celebrity's name to proper capitalization" do
      contact = create(:customer, first_name: "JoHN", last_name: "dOE", email: "John@gmail.com")
      expect(contact.full_name).to eq("John Doe")
    end
  end



  describe "get_celebrity_status" do

      context "when customer has social data" do
        it "checks the different social channels for hits" do
          expect(super_celebrity).to receive(:set_imdb)
          expect(super_celebrity).to receive(:set_wikipedia)
          expect(super_celebrity).to receive(:set_social_data)
          super_celebrity.shop.imdb_notification = true
          super_celebrity.get_external_data
          super_celebrity.send(:get_celebrity_status)
        end
      end



      context "when customer does not have social data" do
        it "doesnt check fullcontact" do
          expect(customer).not_to receive(:set_imdb)
          expect(customer).not_to receive(:set_wikipedia)
          expect(customer).not_to receive(:set_social_data)
          customer.shop.imdb_notification = true
          customer.get_external_data
          customer.send(:get_celebrity_status)
        end
      end

      context "when customer is invalid" do
        it "doesnt check any external sources" do
          expect(customer).not_to receive(:set_imdb)
          expect(customer).not_to receive(:set_wikipedia)
          expect(customer).not_to receive(:set_social_data)
          customer.send(:get_celebrity_status)
        end
      end

  end

  # describe "scan" do 

  #   shop_with_high_standards = build(:shop, :twitter_follower_threshold => 500000, :klout_score_threshold => 99, :instagram_follower_threshold => 100000)
  #   customer = build(:twitter_celebrity, :shop => shop_with_high_standards)
  #   customer.scan

  #   twitter_celebrity = build(:twitter_celebrity)
  #   twitter_celebrity.scan


  #   context "when customer's social data does not meet store min threshold" do
  #     it "saves the data" do
  #       expect(customer.twitter_followers).to be > 500
  #     end

  #     it "is not a celebrity" do
  #       expect(customer.status).to eq("regular")
  #     end
  #   end


  #   context "when customer's social data does meet store min threshold" do
  #     it "saves the data" do
  #       expect(twitter_celebrity.twitter_followers).to be > 500
  #     end

  #     it "is  a celebrity" do
  #       expect(twitter_celebrity.status).to eq("celebrity")
  #     end
  #   end
  # end


  describe "set_social_data" do
    it "calls methods to set social profile data" do
      expect(super_celebrity).to receive(:set_twitter)
      expect(super_celebrity).to receive(:set_linkedin)
      expect(super_celebrity).to receive(:set_angellist)
      expect(super_celebrity).to receive(:set_klout)
      expect(super_celebrity).to receive(:set_instagram)
      expect(super_celebrity).to receive(:set_youtube)
      super_celebrity.set_social_data
    end
  end



  describe "social_data" do
    it "returns an array when customer has social data" do
    end

    it "returns nil when customer has no social data" do
    end
  end

 describe "celebrity?" do

    context 'when customer has twitter followers above store threshold' do
      it 'returns true if customer is a twitter celebrity' do
        expect(twitter_celebrity.celebrity?).to be true
      end
    end

    context 'when customer has twitter followers below store threshold' do
      it 'returns false or nil if customer is not a twitter celebrity' do
        no_twitter_celebrity = build(:customer, twitter_followers: 0)
        expect(no_twitter_celebrity.celebrity?).not_to be
      end
    end

    context 'when customer is imdb celebrity and imdb notifications turned on' do
      it 'returns true if customer is an imdb celebrity' do
        imdb_celebrity.imdb_url = "imdb.com"
        expect(imdb_celebrity.celebrity?).to be true
      end
    end

    context 'when customer is imdb celebrity and imdb notifications turned off' do
      it 'returns false' do
        imdb_celebrity.imdb_url = "imdb.com"
        imdb_celebrity.shop.imdb_notification = false
        expect(imdb_celebrity.celebrity?).not_to be
      end
    end

    context 'when customer is wikipedia celebrity and wikipedia notifications turned on' do
      it 'returns true' do
        wikipedia_celebrity.wikipedia_url = "wikipedia.com"
        expect(wikipedia_celebrity.celebrity?).to be true
      end
    end

    context 'when customer is wikipedia celebrity and wikipedia notifications turned off' do
      it 'returns false' do
        wikipedia_celebrity.wikipedia_url = "wikipedia.com"
        wikipedia_celebrity.shop.wikipedia_notification = false
        expect(wikipedia_celebrity.celebrity?).not_to be
      end
    end

  end


  describe "setting social profiles" do

    super_celebrity = build(:super_celebrity)
    super_celebrity.fullcontact_data

    describe "set_twitter" do

      context "customer has a twitter profile" do
        it "sets the customers twitter data" do
          super_celebrity.send(:set_twitter)
          expect(super_celebrity.twitter_followers).to be
          expect(super_celebrity.twitter_url).to be
        end
      end

      context "customer does not have a twitter profile" do
        it "does not change the customer" do
          imdb_celebrity.fullcontact_data
          expect(imdb_celebrity.send(:set_twitter)).not_to be
        end
      end

    end

    describe "set_youtube" do

      context "customer has a youtube profile" do
        it "sets the customers youtube data" do
          super_celebrity.send(:set_youtube)
          expect(super_celebrity.youtube_subscribers).to be
          expect(super_celebrity.youtube_username).to be
          expect(super_celebrity.youtube_url).to be
          expect(super_celebrity.youtube_views).to be
        end
      end

      context "customer does not have a youtube profile" do
        it "does not change the customer" do
          imdb_celebrity.fullcontact_data
          expect(imdb_celebrity.send(:set_youtube)).to be nil
        end
      end

    end

    describe "set_instagram" do

      context "customer has a instagram profile" do
        it "sets the customers instagram data" do
          super_celebrity.get_external_data
          super_celebrity.send(:set_klout)
          super_celebrity.send(:set_instagram)
          expect(super_celebrity.instagram_id).to be
          expect(super_celebrity.instagram_followers).to be
        end
      end

      context "customer does not have a instagram profile" do
        it "does not change the customer" do
          imdb_celebrity.fullcontact_data
          expect(imdb_celebrity.send(:set_instagram)).to be nil
        end
      end

    end

    describe "set_linkedin" do

      context "customer has a linkedin profile" do
        it "sets the customers linkedin data" do
          super_celebrity.send(:set_linkedin)
          expect(super_celebrity.linkedin_bio).to be
          expect(super_celebrity.linkedin_url).to be
        end
      end

      context "customer does not have a linkedin profile" do
        it "does not change the customer" do
           imdb_celebrity.fullcontact_data
          expect(imdb_celebrity.send(:set_linkedin)).to be nil
        end
      end

    end

    describe "set_angellist" do

      context "customer has a angellist profile" do
        it "sets the customers angellist data" do
          super_celebrity.send(:set_angellist)
          expect(super_celebrity.angellist_url).to be
          expect(super_celebrity.angellist_bio).to be
        end
      end

      context "customer does not have a angellist profile" do
        it "does not change the customer" do
          imdb_celebrity.fullcontact_data
          expect(imdb_celebrity.send(:set_angellist)).to be nil
        end
      end

    end

    describe "set_wikipedia" do

      context "customer has a wikipedia profile" do
        it "sets the customers wikipedia data" do
          super_celebrity.wikipedia_data
          super_celebrity.send(:set_wikipedia)
          expect(super_celebrity.wikipedia_bio).to be
          expect(super_celebrity.wikipedia_url).to be
        end
      end

      context "customer does not have a wikipedia profile" do
        it "does not change the customer" do
          imdb_celebrity.wikipedia_data
          expect(imdb_celebrity.send(:set_wikipedia)).to be nil
        end
      end

    end

    describe "set_imdb" do

      context "customer has a imdb profile" do
        it "sets the customers imdb data" do
          super_celebrity.imdb_data
          super_celebrity.send(:set_imdb)
          expect(super_celebrity.imdb_bio).to be
          expect(super_celebrity.imdb_url).to be
        end
      end

      context "customer does not have a imdb profile" do
        it "does not change the customer" do
          wikipedia_celebrity.imdb_data
          expect(wikipedia_celebrity.send(:set_imdb)).to be nil
        end
      end

    end

  end

  describe "get external data" do
    it "gets external data from imdb, wikipedia, and fullcontact" do
      expect(customer).to receive(:wikipedia_data)
      expect(customer).to receive(:imdb_data)
      expect(customer).to receive(:fullcontact_data)
      customer.get_external_data
    end
  end

  describe "wikipedia_data" do
    it "gets a wikipedia JSON object" do

    end
  end

  describe "imdb_data" do
    it "gets an IMDB JSON object" do
    end
  end

end

#   describe "fullcontact_data" do

#     celebrity = build(:twitter_celebrity)

#     it "instantiates a fullcontact object" do
#       expect(Fullcontact).to receive(:new)
#     end

#     it "sets scanned on social to true" do
#       expect(celebrity.scanned_on_social).to be
#     end
#   end

# end



# context "when customers name has non ascii characters" do 
#         it "will not call get_imdb" do 
#           celebrity = build(:imdb_celebrity, first_name: "Sæthlangøy")
#           expect(celebrity).not_to be_valid
#         end
#       end

#       context "when customer has a first name but not a last name" do
#         it "returns nil" do
#           celebrity = build(:celebrity, last_name: nil)
#           expect(GetCelebrityStatus.call(celebrity)).to be nil
#         end
#       end

#       context "when customer has a last name but not a first name" do
#         it "returns nil" do
#           celebrity = build(:celebrity, first_name: nil)
#           expect(GetCelebrityStatus.call(celebrity)).to be nil
#         end
#       end

#       context "when customer does not have a first name or a last name" do
#         it "returns nil" do
#           celebrity = build(:celebrity, first_name: nil, last_name: nil)
#           expect(GetCelebrityStatus.call(celebrity)).to be nil
#         end
#       end


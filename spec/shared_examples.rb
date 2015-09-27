shared_context "shared examples" do

  let(:fullcontact_array_without_followers) {
    [{"type"=>"twitter",
    "typeId"=>"twitter",
    "typeName"=>"Twitter",
    "url"=>"https://twitter.com/zino0121",
    "username"=>"zino0121",
    "id"=>"1450305547"}]
   }

   let(:fullcontact_hash_without_type) {
    {"typeId"=>"twitter",
    "typeName"=>"Twitter",
    "url"=>"https://twitter.com/zino0121",
    "username"=>"zino0121",
    "id"=>"1450305547",
    "followers"=> 123
     }
   }

   let(:fullcontact_data_array) {
    [{"bio"=>"Change Agent at IBM Design",
    "type"=>"linkedin",
    "typeId"=>"linkedin",
    "typeName"=>"LinkedIn",
    "url"=>"https://www.linkedin.com/in/steveddaniels",
    "username"=>"steveddaniels"},
   {"type"=>"klout",
    "typeId"=>"klout",
    "typeName"=>"Klout",
    "url"=>"http://klout.com/steveddaniels",
    "username"=>"steveddaniels",
    "id"=>"32088152110190636"},
   {"followers"=>1343,
    "following"=>1343,
    "type"=>"facebook",
    "typeId"=>"facebook",
    "typeName"=>"Facebook",
    "url"=>"https://www.facebook.com/sleevedaniels",
    "username"=>"sleevedaniels",
    "id"=>"1385190060"},
   {"type"=>"vimeo",
    "typeId"=>"vimeo",
    "typeName"=>"Vimeo",
    "url"=>"http://vimeo.com/mkshftmag",
    "username"=>"mkshftmag",
    "id"=>"8360391"},
   {"bio"=>
     "Products with soul. Bringing design to value-based care at @ablehealth. Formerly @ibmdesign, @ibmresearch, @mkshftmag, @betterxdesign.",
    "followers"=>1770,
    "following"=>961,
    "type"=>"twitter",
    "typeId"=>"twitter",
    "typeName"=>"Twitter",
    "url"=>"https://twitter.com/steveddaniels",
    "username"=>"steveddaniels",
    "id"=>"19015299"},
   {"type"=>"googleprofile",
    "typeId"=>"googleprofile",
    "typeName"=>"Google Profile",
    "url"=>"https://plus.google.com/u/0/112334779745783722244",
    "id"=>"112334779745783722244"},
   {"type"=>"gravatar",
    "typeId"=>"gravatar",
    "typeName"=>"Gravatar",
    "url"=>"https://gravatar.com/ibmsocialcomp",
    "username"=>"ibmsocialcomp",
    "id"=>"18013099"},
   {"type"=>"quora",
    "typeId"=>"quora",
    "typeName"=>"Quora",
    "url"=>"http://www.quora.com/steve-daniels",
    "username"=>"steve-daniels"},
   {"type"=>"flickr",
    "typeId"=>"flickr",
    "typeName"=>"Flickr",
    "following"=>1343,
    "type"=>"facebook",
    "typeId"=>"facebook",
    "typeName"=>"Facebook",
    "url"=>"https://www.facebook.com/sleevedaniels",
    "username"=>"sleevedaniels",
    "id"=>"1385190060"},
   {"type"=>"vimeo",
    "typeId"=>"vimeo",
    "typeName"=>"Vimeo",
    "url"=>"http://vimeo.com/mkshftmag",
    "username"=>"mkshftmag",
    "id"=>"8360391"},
   {"bio"=>
     "Products with soul. Bringing design to value-based care at @ablehealth. Formerly @ibmdesign, @i
  bmresearch, @mkshftmag, @betterxdesign.",
    "followers"=>1770,
    "following"=>961,
    "type"=>"twitter",
    "typeId"=>"twitter",
    "typeName"=>"Twitter",
    "url"=>"https://twitter.com/steveddaniels",
    "username"=>"steveddaniels",
    "id"=>"19015299"},
   {"type"=>"googleprofile",
    "typeId"=>"googleprofile",
    "typeName"=>"Google Profile",
    "url"=>"https://plus.google.com/u/0/112334779745783722244",
    "id"=>"112334779745783722244"},
   {"type"=>"gravatar",
    "typeId"=>"gravatar",
    "typeName"=>"Gravatar",
    "url"=>"https://gravatar.com/ibmsocialcomp",
    "username"=>"ibmsocialcomp",
    "id"=>"18013099"},
   {"type"=>"quora",
    "typeId"=>"quora",
    "typeName"=>"Quora",
    "url"=>"http://www.quora.com/steve-daniels",
    "username"=>"steve-daniels"},
   {"type"=>"flickr",
    "typeId"=>"flickr",
    "typeName"=>"Flickr",
    "url"=>"https://www.flickr.com/people/brownwib",
    "username"=>"brownwib",
    "id"=>"37359362@n07"},
   {"type"=>"foursquare",
    "typeId"=>"foursquare",
    "typeName"=>"Foursquare",
    "url"=>"https://foursquare.com/user/1593916",
    "id"=>"1593916"},
   {"followers"=>290,
    "following"=>353,
    "type"=>"pinterest",
    "typeId"=>"pinterest",
    "typeName"=>"Pinterest",
    "url"=>"http://www.pinterest.com/stevezie/",
    "username"=>"stevezie"},
   {"bio"=>
     "I use technology to promote making and creativity around the world, especially in environments of scarcity.",
    "type"=>"aboutme",
    "typeId"=>"aboutme",
    "typeName"=>"About.me",
    "url"=>"https://about.me/steveddaniels",
    "username"=>"steveddaniels"}]
   }

   let(:fullcontact_twitter_hash) {
    {"bio"=>
    "Products with soul. Bringing design to value-based care at @ablehealth. Formerly @ibmdesign, @ibmresearch, @mkshftmag, @betterxdesign.",
   "followers"=>1770,
   "following"=>961,
   "type"=>"twitter",
   "typeId"=>"twitter",
   "typeName"=>"Twitter",
   "url"=>"https://twitter.com/steveddaniels",
   "username"=>"steveddaniels",
   "id"=>"19015299"}
   }

   let(:fullcontact_klout_hash) {
      {"type"=>"klout",
      "typeId"=>"klout",
      "typeName"=>"Klout",
      "url"=>"http://klout.com/Ericbobmyers",
      "username"=>"Ericbobmyers",
      "id"=>"27043"}
   }


  let(:klout_api_hash) {
    {"kloutId"=>"27043", 
     "nick"=>"Ericbobmyers", 
     "score"=>{"score"=>63.05425156135237, 
      "bucket"=>"60-69"}, 
      "scoreDeltas"=>{
          "dayChange"=>0.8801018966145193, 
          "weekChange"=>5.259996562121209, 
          "monthChange"=>3.6855222563244183
      }
    }
  }


    let(:wikipedia_dead_celebrity_string) {
     "Robert Lee Frost (March 26, 1874 – January 29, 1963) was an American poet. His work was initially published in England before it was published in America."
    }
    let(:wikipedia_alive_celebrity_string) {
     "Robert Lee Frost (March 26, 1974) was an American poet. His work was initially published in England before it was published in America."
    }

    let(:common_string) {
     "This is a common name and may refer to many people"
    }

    let(:redirect_string) {
     "This is a redirect. please choose wisely"
    }

    let(:imdb_data) {
                     {"id"=>"nm1080980",
                     "title"=>"",
                     "name"=>"Jackson Cunningham",
                     "description"=>"Actor, 10-Speed"}
    }

    let(:json_uri) { "https://en.wikipedia.org/w/api.php?action=opensearch&search=John%20Travolta&limit=1&namespace=0&format=json" }
    let(:invalid_page) { "http://www.vivomasks.com/sdswr" }


    let(:shop) { FactoryGirl.create(:shop, twitter_follower_threshold: 1) }
    let(:shop_without_notifications) { FactoryGirl.create(:shop, twitter_follower_threshold: 1, email_notifications: false) }


    # Use build instead of create as celebrity validation will fail
    # on create and won't be able to create it in first place
    let(:celebrity) { FactoryGirl.build(:celebrity, shop: shop) }
    let(:twitter_celebrity) { FactoryGirl.create(:celebrity, shop: shop, twitter_followers: 2, email: "jacksondcunningham@gmail.com") }
    let(:imdb_celebrity) { FactoryGirl.create(:imdb_celebrity) }
    let(:instagram_celebrity) { FactoryGirl.build(:instagram_celebrity) }

    let(:wikipedia_celebrity) { FactoryGirl.create(:wikipedia_celebrity) }
end

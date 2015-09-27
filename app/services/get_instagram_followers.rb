class GetInstagramFollowers < Services
  def self.call(celebrity)
    instagram_id = celebrity.instagram_id
    source = "https://api.instagram.com/v1/users/#{instagram_id}/?client_id=#{Figaro.env.instagram_client_id}"
    json = GetJSON.call(source)
    json.try(:[], 'data').try(:[], 'counts').try(:[], 'followed_by')
    # json['data']['counts']['followed_by'] if json && json['data'] && json['data']['counts'] && json['data']['counts']['followed_by']
  end
end
module Flickr
  class AuthenticatedUser
    attr_reader :token, :nsid, :username
    
    def initialize(token, nsid, username)
      @token = token
      @nsid = nsid
      @username = username
    end
    
    def self.from_token_response(response)
      new(response.token, response.user.nsid, response.user.username)
    end
  end
end
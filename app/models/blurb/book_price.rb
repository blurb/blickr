module Blurb
  class BookPrice < ActiveResource::Base
    self.site = "http://api-dev.blurb.com/api/v1"
    headers['X-BlurbApiKey'] = BLURB_API_KEY
  end
end
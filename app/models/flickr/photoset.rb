module Flickr
  class Photoset
    def self.fetch_list(nsid)
      flickr.photosets.getList(:user_id => nsid).map do |photoset|
        new(photoset)
      end
    end
    
    def initialize(response)
      @response = response
    end
    
    def photoset_id
      @response.id
    end
    
    def title
      @response.title
    end
    
    def primary_thumbnail_url
      flickr.photos.getSizes(:photo_id => @response.primary).find {|info| info.label == 'Thumbnail'}.source
    end
    
    def price
      Blurb::BookPrice.find(:first, :params => {:book_type => "square", :cover_type => "softcover", :pages => count}).prices.select{|p| p.currency == 'USD'}.first.value
    end
    
    def purchasable?
      minimum_photos? && maximum_photos? && even_photos?
    end
    
    def even_photos?
      count.even?
    end
    
    def minimum_photos?
      count >= 20
    end

    def maximum_photos?
      count < 440
    end

    def count
      @response.photos.to_i
    end
  end
end
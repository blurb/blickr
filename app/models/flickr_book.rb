class FlickrBook
  def initialize(photoset_id, token)
    flickr.auth.checkToken :auth_token => token
    
    response = flickr.photosets.getPhotos :photoset_id => photoset_id, :extras => 'url_o,url_l'
    @info = flickr.photosets.getInfo(:photoset_id => photoset_id)
    @photos = response.photo    
  end
    
  def photo_attr(photo, method_st)
    return photo.send(method_st + '_o') if photo.respond_to?(method_st + '_o')
    photo.send(method_st + '_l')
  end
  
  def to_xml
    xml = Builder::XmlMarkup.new :indent => 2
    
    xml.Book :format => "square" do
      xml.BookMetaData :title => @info.title, :author => "Michael"
      
      xml.PageLayout :layout => "centered"
      
      xml.Cover do
        xml.FrontCover do
          xml.Image :src => photo_attr(@photos.first, "url"), :width => photo_attr(@photos.first, "width"), :height => photo_attr(@photos.first, "height")
        end
      end
      
      xml.Images do
        @photos.each do |p|
          xml.Image :src => photo_attr(p, "url"), :width => photo_attr(p, "width"), :height => photo_attr(p, "height")
        end
      end
    end
  end
end
require 'oauth'
require 'oauth/consumer'
require 'digest/md5'

class FlickrController < ApplicationController
  before_filter :authenticate_flickr, :only => [:index, :make_book]
  before_filter :authenticate_blurb, :only => [:index, :make_book]
  
  def index
    @photosets = Flickr::Photoset.fetch_list(@auth.nsid)
  end
  
  def make_book
    resp = access_token.post("/api/v1/photobook_jobs.xml", :book_xml => FlickrBook.new(params["photoset_id"], @auth.token).to_xml, 
      :api_key => BLURB_API_KEY, :sig => Digest::MD5.hexdigest(BLURB_API_KEY + BLURB_API_SECRET + Time.now.to_i.to_s))
    id = resp.body.match(/<id.*>(\d+)<\/id>/)[1]
    redirect_to :action => "show", :id => id
  end
  
  def show
    @job = Blurb::PhotobookJob.find(params[:id])
    redirect_to @job.book_url if @job.status == 'READY'
  end
  
  def callback
    token = flickr.auth.getToken :frob => params['frob']
    session[:flickr_token] = Flickr::AuthenticatedUser.from_token_response(token).token
    redirect_to :action => "index"
  end
  
  def blurb_callback
    access_token = session[:request_token].get_access_token(:oauth_verifier => params[:oauth_verifier])
    session[:access_token] = access_token.token
    session[:access_token_secret] = access_token.secret
    redirect_to :action => "index"
  end
  
private
  def consumer    
    OAuth::Consumer.new "nKmHSNcx5vgrPDGlbWUx", "Z83ltpULjipEhXoYOy6kjJpiSDxx8rseBnbppf9a", {:site => "http://local.blurb.com:3000"}
  end
  
  def access_token
    OAuth::AccessToken.new consumer, session[:access_token], session[:access_token_secret]
  end
  
  def authenticate_blurb
    return if blurb_authenticated?
    request_token = consumer.get_request_token
    session[:request_token] = request_token
    redirect_to request_token.authorize_url
  end
  
  def authenticate_flickr
    return if flickr_authenticated?
    frob = flickr.auth.getFrob
    url = FlickRaw.auth_url :frob => frob, :perms => 'read'      
    redirect_to url
  end
  
  def blurb_authenticated?
    !session[:access_token].nil?
  end
  
  def flickr_authenticated?
    return false if session[:flickr_token].nil?
    @auth = Flickr::AuthenticatedUser.from_token_response(flickr.auth.checkToken(:auth_token => session[:flickr_token]))
    true
  rescue => e
    false
  end
end
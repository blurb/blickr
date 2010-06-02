FlickRaw.api_key = "ec1ef6d8ec02c0427621083fd5661988"
FlickRaw.shared_secret = "c32f6e7849c4fa6b"

class ActiveResource::Connection
  # Creates new Net::HTTP instance for communication with
  # remote service and resources.
  def http
    http = Net::HTTP.new(@site.host, @site.port)
    http.use_ssl = @site.is_a?(URI::HTTPS)
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE if http.use_ssl
    http.read_timeout = @timeout if @timeout
    #Here's the addition that allows you to see the output
    http.set_debug_output $stderr
    return http
  end
end
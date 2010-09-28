require 'net/http'
require 'net/https'

module HasOffers
  
  class API
    attr_accessor :authentication
    attr_accessor :default_params
    
    # Set to true to enable debugging (off by default)
    attr_accessor :debug_mode

    # Set to true to enable test mode (off by default)
    attr_accessor :test_mode

    API_SERVICE_HOST = 'https://api.hasoffers.com/Api'
    
    # Initialize a HasOffers object with the authentication values
    # This accepts
    #   1. A string declaring a YAML file with the correct api_key and network_id
    #   2. A hash containing the api_key and network_id
    #   3. By default, if left empty, it will look for config/has_offer.yml file to declare the authentication
    def initialize(authentication = nil)
      if authentication.nil? || authentication.is_a?(String)
        config_file = authentication.nil? ? 'config/has_offers.yml' : authentication
        @authentication = YAML::load(IO.read(config_file)) if File.exists?(config_file)
      elsif authentication.is_a?(Hash)
        @authentication = authentication
      end
      @default_params = { 'Format' => 'json',
                          'Service' => 'HasOffers',
                          'Version' => '2',
                          'NetworkId' => @authentication['network_id'],
                          'NetworkToken' => @authentication['api_key'] }
      self.debug_mode = false
      self.test_mode = false
    end
    
    def new_http(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http
    end
    
    def get_conversions(options={})
      params = options
      params['Method'] = 'getConversions'
      params['Target'] = 'Report'
      params.merge!(@default_params)
      
      uri = URI.parse("#{API_SERVICE_HOST}?#{params.to_params.gsub(/\[\]\[/,'[')}")
      http = new_http uri
      raw_request = Net::HTTP::Get.new(uri.request_uri)
      http_response = http.request raw_request
      Response.new http_response
    end
  end
  
  def query_string(params)
    # Rails to_params adds an extra open close brackets to multi-dimensional array parameters which
    # hasoffers doesn't like, so the gsub here takes care of that.
    params.to_params.gsub(/\[\]\[/,'[')
  end
  
end
module HasOffers
  
  class Response
    
    attr_reader :body, :http_status_code, :http_message, :http_headers
    
    def success?
      @http_status_code.to_s == '200' and status == 1
    end
    
    def status
      @body['response']['status']
    end
    
    def initialize(response)
      @test = false
      @body = JSON.parse(response.body)
      @http_status_code = response.code
      @http_message = response.message
      @http_headers = response.to_hash
    end
    
  end
  
end
module HasOffers
  
  class Response
    
    attr_reader :body, :http_status_code, :http_message, :http_headers
    
    def success?
      @http_status_code.to_s == '200' and status == 1
    end
    
    def status
      @body['response']['status']
    end
    
    # allows specific api calls to post-process the data for ease of use
    def set_data(data)
      @processed_data = data
    end

    def raw_data
      @body
    end

    def data
      @processed_data || (paginated_response? ? @body['response']['data']['data'] : @body['response']['data'])
    end
    
    def page_info
      if paginated_response?
        {'page_count' => @body['response']['data']['pageCount'],
         'current' => @body['response']['data']['current'],
         'count' => @body['response']['data']['count'],
         'page' => @body['response']['data']['page']}
      else
        {}
      end
    end

    def validation_error?
      status == -1 and data['error_code'] == 1
    end

    def error_messages
      if data.is_a? Hash and data["errors"] and data["errors"]["error"]
        data["errors"]["error"].map { |error| error["err_msg"] }
      elsif @body["response"]["errors"]
        @body["response"]["errors"].map { |error| error["err_msg"] }
      else
        []
      end
    end

    def initialize(response)
      @test = false
      @body = JSON.parse(response.body)
      @http_status_code = response.code
      @http_message = response.message
      @http_headers = response.to_hash
    end
    
    protected

      def paginated_response?
        @body['response']['data'] and @body['response']['data'].is_a?(Hash) and @body['response']['data']['pageCount']
      end
    
  end
  
end
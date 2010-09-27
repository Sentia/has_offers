module HasOffers
  
  class API
    attr_accessor :authorization
    
    # TODO - Load Auth from a YAML file as well
    def initialize(authorization = {})
      @authorization = authorization
    end
    
  end
  
end
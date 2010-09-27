# module HasOffers end

require 'lib/has_offers/api'
%w(
has_offers/api
).each do |lib|
  require File.join(File.dirname(__FILE__), lib)
end
# 
# directory = File.expand_path(File.dirname(__FILE__))
# require File.join(directory, "has_offers", "api")
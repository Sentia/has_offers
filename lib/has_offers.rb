require 'httparty'

%w(
has_offers/api
).each do |lib|
  require File.join(File.dirname(__FILE__), lib)
end

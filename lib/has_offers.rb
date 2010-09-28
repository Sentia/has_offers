%w(
has_offers/api
has_offers/response
).each do |lib|
  require File.join(File.dirname(__FILE__), lib)
end

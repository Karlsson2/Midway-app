require 'rubygems'
require 'json'
require 'open-uri'

class FoursquareService

  def initialize(attributes = {})
    @location = attributes[:location]
    @radius = attributes[:radius]
    @categoryid = attributes[:categoryid]
    @venue_id = attributes[:venue_id]

    # if we weant to let them search themselves we can implement logic below to let them search
    #@category = attributes[:category]
  end

  def find_venues

    # find how to hide api key
    client_id = ENV["FOURSQUARE_CLIENT_ID"]
    client_secret = ENV["FOURSQUARE_CLIENT_SECRET"]

    base_url = "https://api.foursquare.com/v2/venues/search?client_id=#{client_id}&client_secret=#{client_secret}"

    # Location comes as a string => "51.492035164043834,-0.15026726093747364"
    longitude = @location.split(",")[0]
    latitude = @location.split(",")[1]

    radius = @radius.to_s
    categoryid = @categoryid

    # v for version, current date works
    url = base_url + "&near=#{longitude},#{latitude}&radius=#{radius}&categoryId=#{categoryid}&v=20201126"
    json = JSON.parse(open(url).read)
    venues = json["response"]["venues"]

  end

  def venue_info
    url = "https://api.foursquare.com/v2/venues/#{@venue_id}?client_id=#{ENV["FOURSQUARE_CLIENT_ID"]}&client_secret=#{ENV["FOURSQUARE_CLIENT_SECRET"]}&v=20201126"
    json = JSON.parse(open(url).read)
    venue_info = json["response"]["venue"]
  end

end

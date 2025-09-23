class MarketDataFetcher
  include HTTParty
  base_uri "https://api.cultivationdata.net"

  def initialize(city = "0000", cat = "v")
    @options = { query: { cc: city, cat: cat } }
  end

  def fetch
    self.class.get("/wmr", @options)
  end
end

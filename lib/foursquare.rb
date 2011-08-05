class FoursquareAdapter


  def initialize(token=nil)
    if (token)
      @foursquare = Foursquare::Base.new(token)
      @user = @foursquare.users.find("self")
    else
      @foursquare = Foursquare::Base.new("JRUBR0P0XBZRNZTMG5ROLJK1O50YLJNI0H0ZRKUY5RXHNRQW", "NBAYJQHPSZGHDFNQUS4INWUCM5MN4I1AHTNWYUL3UHOIA2CY")
    end
  end

  def get_login_url
    @foursquare.authorize_url("http://bttr.me:3000/callback")
  end

  def authenticate(code)
    @foursquare.access_token(code, "http://bttr.me:3000/callback")
  end

  def checkins

  end

  def user
    @user
  end

end


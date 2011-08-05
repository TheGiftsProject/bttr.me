require 'foursquare'
require 'filters'
class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :init_foursquare
  before_filter :must_be_logged_in, :except => [:callback]

  def current

    @missions = {}
    [:day,:week,:month].each do |timespan|
      missions = Mission.find_all_by_timespan(timespan)
      missions.each do |m|
        m.run(@user)
      end
      @missions[timespan] = missions
    end
  end

  def new

  end

  def create
    puts params
    redirect_to new_mission_path
  end

  def callback
    session[:access_token] = @foursquare.authenticate(params["code"])
    redirect_to root_path
  end

  private

  def init_foursquare
    @foursquare = FoursquareAdapter.new(session[:access_token])
  end

  def must_be_logged_in
    if (!session[:access_token])
      redirect_to @foursquare.get_login_url
    end
    @user = @foursquare.user
  end

end

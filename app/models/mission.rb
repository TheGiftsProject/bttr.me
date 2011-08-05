class Mission < ActiveRecord::Base
  has_many :filters

  attr_accessible :name # add user_id
  attr_accessible :chks

  def run(user)
    @user = user
    @chks = checkins
    filters.each do |filter|
      @chks = filter.filter(@chks)
    end
    successful(@chks)
  end

  def success?
    @success
  end

  def chks
    @chks
  end

  private

  def successful(checkins)
    @success = ((checkins.count <=> multiplier) * (min? ? 1 : -1)) > -1
  end

  def date_range
    @date_range ||= ((Time.now-1.send(timespan))..Time.now)
  end

  def checkins
    checkins = []
    timestamp = date_range.first.to_i
    begin
      chkns = @user.checkins(:afterTimestamp=>timestamp)
      filtered_chkns = chkns.reject {|c| c.created_at > date_range.last}
      checkins.concat(filtered_chkns)
      timestamp = chkns.first.created_at.to_i+5 unless chkns.empty?
    end while (!chkns.empty? && filtered_chkns.count >= chkns.count)

    checkins
  end

end

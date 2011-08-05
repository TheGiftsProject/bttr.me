class Filter < ActiveRecord::Base
  belongs_to :mission

  def filter(checkins)
    checkins
  end
end

class VenueFilter < Filter
  attr_accessible :venue,:category

  def filter(checkins)
    checkins.reject do |checkin|
      v = checkin.venue
      if self.venue
        self.venue != v.id
      elsif self.category
        if v.primary_category.nil?
          true
        else
          categories = v.primary_category.parents.map(&:downcase) + [v.primary_category.name.downcase]
          !categories.include?(self.category.to_s)
        end
      else
        false
      end
    end
  end
end


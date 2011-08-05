module Filters
  
   class Modifier
     def initialize(data={})
       data = {:amount=>1,:minmax=>:min}.merge(data)
       @amount = data[:amount]
       @minmax = data[:minmax]
     end
     def status(checkins)
       ((checkins.count <=> @amount) * (@minmax == :max ? -1 : 1)) > -1
     end
   end

   class Timespan
     def initialize(params={})
       params = {:timespan=>:week}.merge(params)
       @date_range = ((Time.now-1.send(params[:timespan]))..Time.now)
     end
     def checkins(user)
       checkins = []
       timestamp = @date_range.first.to_i
       begin
         chkns = user.checkins(:afterTimestamp=>timestamp)
         filtered_chkns = chkns.reject {|c| c.created_at > @date_range.last}
         checkins.concat(filtered_chkns)
         timestamp = chkns.first.created_at.to_i+5 unless chkns.empty?
       end while (!chkns.empty? && filtered_chkns.count >= chkns.count)

       checkins
     end
     def convert_date_range_to_filter(daterange)
         {:afterTimetamp=>daterange.first.to_i}
      end
    end

   class Venue
     def initialize(params={})
       @params = params
     end

     def filterz(checkins)
       checkins.reject do |checkin|
         v = checkin.venue
         if @params[:venue]
           @params[:venue] != v.id
         elsif @params[:category]
           categories = v.primary_category.parents.map(&:downcase) + [v.primary_category.name.downcase]
           !categories.include?(@params[:category].to_s)
         else
           false
         end
       end
     end
   end
end

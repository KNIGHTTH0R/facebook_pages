module FacebookPages
    class FacebookPageInsightRow
        attr_accessor :data
        attr_accessor :end_time

        def initialize end_time
            @end_time = end_time
            @data = Hash.new
        end
    end
end
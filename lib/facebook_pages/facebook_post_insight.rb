module FacebookPages
    class FacebookPostInsight
        def initialize data
            @data = data
        end

        def insights
            return FacebookPostInsightRow.new(get_insights)
        end

        def get_insights
           return @data["data"] 
        end
    end
end
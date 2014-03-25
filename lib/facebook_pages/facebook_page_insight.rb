module FacebookPages
    class FacebookPageInsight
        def initialize data
            @data = data
        end

        def daily_insights
            insights = get_insights "day"
            return FacebookPageInsightTable.new(insights)
        end

        def weekly_insights
            insights = get_insights "week"
            return FacebookPageInsightTable.new(insights) 
        end

        def lifetime_insights
            insights = get_insights "lifetime"
            return FacebookPageInsightTable.new(insights) 
        end

        def get_insights period
            result = Array.new
            @data["data"].each {|insight|
                if insight["period"].to_s == period.to_s
                    result.push(insight)
                end
            }
            result
        end
    end
end
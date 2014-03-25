require 'active_support'
require 'active_support/time'

module FacebookPages
    class FacebookPage
        def initialize id, api = nil
            @page_id = id
            @api = api
            FacebookAPIWrapper.set_instance @api
        end

        def analyzer
            return FacebookPageAnalyzer.new(self)
        end

        def data
            unless @data
                @data = @api.get("/#{@page_id}",{"until" => (Date.today + 1.day).to_s})    
            end
            @data
        end

        def insights date_since = nil, date_until = nil
            unless @page_insights
                params = {
                    "until" => date_until.nil? ? (Date.today - 1.day).to_s : date_until.to_s,
                    "since" => (Date.today - 14.days).to_s
                }
                @page_insights = FacebookPageInsight.new @api.get("/#{@page_id}/insights",params)
            end
            @page_insights
        end

        def feed options = {}
            options["limit"] = 100 unless options["limit"]
            options["filter"] = "stream" unless options["filter"]
            feed_data = Array.new
            feed = @api.get("/#{@page_id}/feed",options)
            feed_data += feed["data"]
            
            while feed_data.size < options["limit"] && feed["paging"] && feed["paging"]["next"]
                feed = @api.get(feed["paging"]["next"])
                feed_data += feed["data"]
            end

            return FacebookPageFeed.new(@page_id, feed_data.take(options["limit"]))
        end

        def likes
            data["likes"]
        end

        def people_talking
            data["talking_about_count"]
        end
    end
end




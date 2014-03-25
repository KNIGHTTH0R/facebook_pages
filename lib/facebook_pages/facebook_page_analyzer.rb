module FacebookPages
    class FacebookPageAnalyzer
        attr_accessor :page

        def initialize page
            @page = page
        end

        def response_time
            posts_analyzer = FacebookPagePostsAnalyzer.new(@page.feed.fan_posts)
            return posts_analyzer.avg("response_time").round(2)
        end
    end
end
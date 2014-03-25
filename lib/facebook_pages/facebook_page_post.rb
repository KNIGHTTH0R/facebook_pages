module FacebookPages
    class FacebookPagePost
        attr_accessor :data
        def initialize data
            @data = data
            @insights = nil
            @post_id = data["id"]
        end

        def created
            return Date.parse(@data["created_time"]).to_s
        end

        def api
            return FacebookAPIWrapper.api
        end

        def engagement
            return comments.count + likes.count + shares
        end

        def response_time
            if comments.count > 0
                replies = comments.select{|c| c["from"]["id"] != @data["from"]["id"]}
                if replies.count > 0
                    return Time.parse(replies.first["created_time"]) - Time.parse(@data["created_time"])
                else
                    return nil
                end
            end
            return nil
        end

        def comments limit = 0
            unless @comments
                @comments = Array.new
                comments_data = api.get("#{@post_id}/comments",{"limit" => 100,"filter" => "stream"})
                @comments += comments_data["data"]
                while comments_data["paging"] && comments_data["paging"]["next"]
                    comments_data = api.get(comments_data["paging"]["next"])
                    @comments += comments_data["data"]
                end
            end
            return @comments.take(limit) if limit > 0
            @comments
        end

        def likes
            unless @likes
                @likes = Array.new
                likes_data = api.get("#{@post_id}/likes",{"limit" => 100})
                @likes += likes_data["data"]
                while likes_data["paging"] && likes_data["paging"]["next"]
                    likes_data = api.get(likes_data["paging"]["next"])
                    @likes += likes_data["data"]
                end
            end
            @likes
        end

        def shares
            return @data["shares"]["count"] if @data["shares"] && @data["shares"]["count"]
            return 0
        end

        def message
            return @data["message"] if @data["message"]
            return @data["story"] if @data["story"]
            return @data["name"] if @data["name"]
            return nil
        end

        def insights
            unless @insights
                @insights = (FacebookPostInsight.new(api.get("/#{@post_id}/insights"))).insights
            end
            @insights
        end
    end
end
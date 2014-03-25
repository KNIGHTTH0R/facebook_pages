module FacebookPages
    class FacebookPageFeed
        attr_accessor :data
        attr_accessor :posts

        def initialize page_id, data
            @page_id = page_id
            @data = data
            build_posts
        end

        def admin_posts limit = nil
            if !limit.nil?
                return filter_posts(true).take(limit)
            end
            filter_posts true
        end

        def fan_posts limit = nil
            if !limit.nil?
                return filter_posts(false).take(limit)
            end
            filter_posts false
        end

        def posts
            @posts
        end

        private
        def build_posts
            @posts = Array.new
            @data.each{|post_data|
                post = FacebookPagePost.new post_data
                @posts.push post
            }
        end

        def filter_posts owner
            result = Array.new
            @posts.each{|post|
                if (owner && post.data["from"]["id"].to_s == @page_id.to_s) && (post.data["status_type"])
                    result.push(post)
                end

                if (!owner && post.data["from"]["id"].to_s != @page_id.to_s)
                    result.push(post)
                end
            }
            result
        end 
    end
end
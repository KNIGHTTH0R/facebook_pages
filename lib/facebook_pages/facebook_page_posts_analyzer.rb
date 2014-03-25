module FacebookPages
    class FacebookPagePostsAnalyzer
        attr_accessor :posts
        def initialize posts = nil
            @posts = posts
        end

        def collection property
            collection = Array.new
            @posts.each{|post|
                collection += post.send(property)
            }
            collection
        end

        def count property
            if is_collection? property
                return collection(property).count    
            else
                return sum @posts.map{|p| p.send property}
            end
        end

        def avg property
            valid_posts = @posts.select{|p| !p.send(property).nil?}
            (count(property)*1.0)/(valid_posts.count * 1.0)
        end

        def group_comments_by_time
            grouped_comments = Array.new
            24.times {grouped_comments.push Array.new} 
            comments = collection("comments")
            comments.each{|comment|
                comment_date = DateTime.parse(comment["created_time"])
                grouped_comments[comment_date.hour].push(comment)
            }
            
            result = Array.new
            grouped_comments.each {|a|
                result.push a.count
            }
            result
        end

        def group_comments_by_dow
            grouped_comments = Array.new
            7.times {grouped_comments.push Array.new}
            comments = collection("comments")
            comments.each{|comment|
                comment_date = DateTime.parse(comment["created_time"])
                grouped_comments[comment_date.wday].push(comment)
            }
            result = Array.new
            grouped_comments.each {|a|
                result.push a.count
            }
            result
        end

        def is_collection? property
            return ["comments","likes"].include? property
        end

        def sum collection
            sum = 0
            collection.each{|item|
                sum += item if !item.nil?
            }
            sum
        end
    end
end
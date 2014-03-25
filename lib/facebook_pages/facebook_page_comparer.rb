module FacebookPages
    class FacebookPageComparer
        attr_accessor :pages

        def initialize pages
            @pages = pages
        end

        def max &block
            max = nil
            @pages.each{|page|
                page_value = block.call(page)
                max = page_value if max.nil? || page_value > max
            }
            max
        end

        def min &block
            min = nil
            @pages.each{|page|
                page_value = block.call(page)
                min = page_value if (min.nil? || (page_value < min))
            }
            min
        end

        def has_max? page, &block
            return max(&block) == block.call(page)
        end

        def has_min? page, &block
            return min(&block) == block.call(page)
        end

        def has_max_likes? page
            return has_max?(page){|p| p.likes}
        end

        def has_max_people_talking? page
            return has_max?(page){|p| p.people_talking}
        end

        def has_min_response_time? page
            return has_min?(page){|p| 
                p.analyzer.response_time
            }
        end
    end
end
module FacebookPages
    class FacebookPostInsightRow
        attr_accessor :data

        def initialize insights
            @data = Hash.new
            build_row insights
        end

        private
        def build_row insights
            insights.each{|insight|
                insight["values"].each{|value|
                    if value["value"].class.to_s == "Hash"
                        value_hash = value["value"]
                        value_hash.keys.each{|key|
                            @data["#{insight['name']}:#{key}"] = value_hash[key]
                        }
                        @data[insight["name"]] = value["value"]
                    else
                        @data[insight["name"]] = value["value"]
                    end
                }
            }
        end
    end
end
module FacebookPages
    class FacebookPageInsightTable
        attr_accessor :rows
        attr_accessor :unique_keys

        def initialize insights
            @insights = insights
            build_rows
            build_keys
        end

        def sum metric
            result = 0
            @rows.each{|row|
                result += row.data[metric]
            }
            result
        end

        def avg metric
            return sum(metric)/@rows.count
        end

        private
        def build_rows
            @rows = Array.new
            @insights.each{|insight|
                insight["values"].each{|value|
                    row = get_row_by_end_time (Date.parse(value["end_time"]) - 1.day).to_s
                    if value["value"].class.to_s == "Hash"
                        value_hash = value["value"]
                        value_hash.keys.each{|key|
                            row.data["#{insight['name']}:#{key}"] = value_hash[key]
                        }
                        row.data[insight["name"]] = value["value"]
                    else
                        row.data[insight["name"]] = value["value"]
                    end
                }
            }
        end

        def build_keys
            @unique_keys = Array.new
            @rows.each{|row|
                row.data.keys.each{|key|
                    @unique_keys.push key unless @unique_keys.include? key
                }
            }
        end

        def get_row_by_end_time end_time
            @rows.each {|row|
                return row if row.end_time == end_time
            }
            row = FacebookPageInsightRow.new end_time
            @rows.push row
            return row
        end
    end
end
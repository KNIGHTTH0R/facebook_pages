module FacebookPages
    class FacebookAPIWrapper
        @@api = nil
        def self.set_instance api
            @@api = api
        end

        def self.api
            @@api
        end
    end
end
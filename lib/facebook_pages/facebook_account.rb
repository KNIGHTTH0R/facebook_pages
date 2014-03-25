module FacebookPages
    class FacebookAccount
        def initialize api
            @api = api if api
        end

        def pages
            res = @api.get("/me/accounts")
            res["data"]
        end

        def get_page_by_name page_name
            "TODO"
        end

        def get_page_by_id page_id
            "TODO"
        end
    end
end
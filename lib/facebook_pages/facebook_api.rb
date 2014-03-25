require 'json'
require 'uri'
require 'cgi'
require 'net/http'

module FacebookPages
    class FacebookAPI
        def initialize token
            @token = token
        end

        def get endpoint, params = {}
            facebook_root = "https://graph.facebook.com/"
            if endpoint.include? "graph.facebook.com"
                unless endpoint.include? "access_token"
                    endpoint += "&access_token=#{@token}"
                end
                base_url = encode_url_token endpoint
            else
                base_url = facebook_root + endpoint + build_params(params)  
            end
            
            # @log.info "request to fb #{base_url}"
            url = URI.parse(base_url)
            http = Net::HTTP.new(url.host, url.port)
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE

            request = Net::HTTP::Get.new(base_url)

            response =  http.request(request)
            # @log.info "response body : #{response.body}"
            jsonResponse = JSON.parse(response.body)

            if (jsonResponse.class.to_s == "Hash") && (jsonResponse["error"])
                unless jsonResponse["error"]["code"].to_s == "601"
                    message = jsonResponse["error"]["message"]
                    type = jsonResponse["error"]["type"]
                    code = jsonResponse["error"]["code"]
                    # @log.warn "Request with error : #{base_url} message : #{message} type : #{type} code : #{code} "
                end
                raise jsonResponse.to_s
            end
            if (jsonResponse.nil?)
                # @log.info "response is nil request : #{base_url}"
            end
            return jsonResponse
        end

        def build_params params
            query_string = ""
            first = true
            params.each{|key,value|
                unless params[key].nil?
                    symbol = first ? "?": "&"
                    query_string += "#{symbol}#{key}=#{value.to_s}"
                    first = false
                end
            }

            symbol = first ? "?": "&"
            query_string += "#{symbol}access_token=#{CGI::escape(@token)}"
            return query_string
        end

        def encode_url_token url
            url_copy = url
            params = CGI::parse(url)
            token = params["access_token"].first
            unless token.nil?
                return url.sub(token,CGI::escape(token))
            end
            return url
        end
    end
end
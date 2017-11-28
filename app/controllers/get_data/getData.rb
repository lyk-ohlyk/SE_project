#encoding UTF-8
require 'net/http'
module EasyHTTP
    class HTTP
        @@count = 0
        def get_cookie
            @cookie
        end
        def initialize(url)
            @sepuser = nil
            @url = url
            @cookie = nil
        end
        def login
            uri =  URI.parse(@url)
            params = {}
            params['userName'] = '444896219@qq.com'
            params['pwd'] = '***'
            params['sb'] = 'sb'
            res = Net::HTTP.post_form(uri , params)
            #puts "logining header:\n#{res.to_hash.inspect}"
            @cookie = res.header['set-cookie'].split('; ')
            @sepuser = @cookie[3]
            /.*(sepuser=".*")/ =~ @sepuser
            @sepuser = $1
            puts "sep:#{@sepuser}"
            #puts "logining........ the cookie is #{@cookie}\n"
        end
        def set_request_header(path)
            request = Net::HTTP::Get.new(path)
            request['Accept'] = "text/html, application/xhtml+xml, */*"
            request['Accept-langeuage'] = "zh-CN"
            request['Cookie'] = nil
            request['DNT'] = 1
            request['Host'] = "course.ucas.ac.cn"
            request['Referer'] = "http://sep.ucas.ac.cn/portal/site/16/801"
            request['User-Agent'] = "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko"
            request['Connect'] = "Keep-Alive"
            request
        end
        def logout
            url = "http://course.ucas.ac.cn/portal/logout"
            uri = URI.parse(url)
            request = Net::HTTP::Get.new(uri.path)
            request['Cookie'] = @cookie
            http = Net::HTTP.new(uri.host , uri.port)
            request = Net::HTTP::Get.new(uri.path)
            res = http.request(request)
            puts res.to_hash.inspect
        end
        def get(url, change_cookie = 0)
            @@count += 1
            p @@count
            puts "the url is:\n#{url}\n"
            login unless @cookie
            uri = URI.parse(url)
            http = Net::HTTP.new(uri.host , uri.port)
            if change_cookie == 1
                request = set_request_header(uri.path)
                request['Cookie'] = @sepuser
                puts "request header is #{request.to_hash.inspect}"
            else
                request = Net::HTTP::Get.new(uri.path)
                request['Cookie'] = @cookie
            end
            res = http.request(request)
            puts "#{res}\n"

            #detect whether there is redirect
            location = res['location']
            if location
                warn "redirected :\n#{res['location']}"
            end
            res.body
        end
        def find_portal(body)
            /<a href="(.*)"><strong>/ =~ body
            $1
        end
        def get_from_identity(portal_1)
            /Identity=(.*)&r/ =~ portal_1
            portal_2 = $1
            "http://course.ucas.ac.cn/portal/plogin/main.do?method=gotoIndex&Identity=" + portal_2 + "&roleId=801&sakai.tool.placement.id=exchange"
        end
    end
end

sample = EasyHTTP::HTTP.new("http://sep.ucas.ac.cn/slogin")
sample.get("http://sep.ucas.ac.cn/appStore",0)

puts "\n\n\nlogout:"
sample.logout
puts "\n\n\n"

body = sample.get("http://sep.ucas.ac.cn/portal/site/16/801",0)
portal_1 = sample.find_portal(body)
sample.get(portal_1,1)

portal_2 = sample.get_from_identity(portal_1)
sample.get(portal_2,0)
#encoding UTF-8
require 'net/http'
module EasyHTTP
    class HTTP
        @@count = 0
        def get_cookie
            @cookie
        end
        def set_cookie(cookie)
            @cookie = cookie + ";" + @sepuser
        end
        def initialize(url)
            @sepuser = nil
            @login = url
            @cookie = nil
        end
        def login
            uri =  URI.parse(@login)
            params = {}
            params['userName'] = '444896219@qq.com'
            params['pwd'] = '360734199506250010'
            params['sb'] = 'sb'
            res = Net::HTTP.post_form(uri , params)
            #puts "logining header:\n#{res.to_hash.inspect}"
            @cookie = res.header['set-cookie'].split('; ')
            @sepuser = @cookie[3]
            /.*(sepuser=".*")/ =~ @sepuser
            @sepuser = $1
            @cookie = @cookie[0]
            puts @cookie
            #puts "#{@sepuser}"
            #puts "logining........ the cookie is #{@cookie}\n"
        end
        def set_request_header(path)
            request = Net::HTTP::Get.new(path)
            request["Accept"] = "text/html, application/xhtml+xml, */*"
            request["Accept-Language"] = "zh-CN"
            request["Connection"] = "Keep-Alive"
            request["Cookie"] = @sepuser
            request["DNT"] = 1
            request["Host"] = "course.ucas.ac.cn"
            request["Referer"] = "http://sep.ucas.ac.cn/portal/site/16/801"
            request["User-Agent"] = "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko"
            request
        end
        def get(url)
            @@count += 1
            puts @@count
            puts "the url is:\n#{url}"
            login unless @cookie
            uri = URI.parse(url)
            http = Net::HTTP.new(uri.host , uri.port)
            request = Net::HTTP::Get.new(uri.path)
            request['Cookie'] = @cookie
            res = http.request(request)
            puts "#{res}\n"

            #detect whether there is redirect
            location = res['location']
            if location
                warn "redirected :#{res['location']}\n"
            end
            res
        end
        def get_with_params(url)
            @@count += 1
            puts @@count
            params = extract_param(url)
            uri = URI.parse(url)
            uri.query = URI.encode_www_form(params)
            puts url
            res = Net::HTTP.get_response(uri)
            # http = Net::HTTP.new(uri.host , uri.port)
            # request = Net::HTTP::Get.new(uri.path)
            # request['Cookie'] = @cookie
            # res = http.request(request)

            puts res

            location = res['location']
            if location
                warn "redirected :#{res['location']}\n"
            end
            res
        end
        def extract_param(url)
            /\?(.*)/ =~ url
            raw_param = $1
            hash_param = raw_param.split(/&/)
            params = Hash.new  
            hash_param.each{|hp|
                k_v = hp.split(/=/)
                params[k_v[0]] = k_v[1]
            }
            params
        end
        def find_portal(body)
            /<a href="(.*)"><strong>/ =~ body
            $1
        end
        def get_portal2(portal_1)
            /Identity=(.*)&r/ =~ portal_1
            portal_2 = $1
            "http://course.ucas.ac.cn/portal/plogin/main.do?method=gotoIndex&Identity=" + portal_2 + "&roleId=801&sakai.tool.placement.id=exchange"
        end
    end
end
sample = EasyHTTP::HTTP.new("http://sep.ucas.ac.cn/slogin")
sample.get("http://sep.ucas.ac.cn/appStore")
body = sample.get("http://sep.ucas.ac.cn/portal/site/16/801").body
portal_1 = sample.find_portal(body)
#puts "\n\n\n #{portal_1}"

portal_2 = sample.get_portal2(portal_1)
res_p2 = sample.get_with_params(portal_2)

location_of_main = res_p2['location']
params = sample.extract_param(location_of_main)
#res_main = sample.get_with_params(location_of_main, sample.extract_param(location_of_main))
portal_sakai = "http://course.ucas.ac.cn/portal?sakai.session="+ params['sessionId'] +"&_mid=" + params['_mid'] + "&fromUrl="
#puts "\n\n#{portal_sakai}"
res_portal_sakai = sample.get_with_params(portal_sakai)
sample.set_cookie(res_portal_sakai['set-cookie'])
user_body = sample.get("http://course.ucas.ac.cn/portal/site/~201728001007002/").body
/membership" href="(.*)"/ =~ user_body
user_membership = $1
user_membership_body = sample.get(user_membership).body
#/<a\shref="(.*)"\starget/ =~ user_membership_body
/\tsrc="(.*)">/ =~ user_membership_body
#tool_reset_site = $1

puts class_site = $1
class_table = sample.get(class_site)
puts class_table.body


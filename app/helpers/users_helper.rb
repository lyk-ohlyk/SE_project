require 'net/http'

module UsersHelper
  def gravatar_for(user, options = {size: 100})
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: 'gravatar')
  end

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
      @id = nil
      @pwd = nil
    end
    def set_user(id, pwd)
      @id = id
      @pwd = pwd
    end
    def login
      uri =  URI.parse(@login)
      params = {}
      params['userName'] = @id
      params['pwd'] = @pwd
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

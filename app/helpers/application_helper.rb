module ApplicationHelper

class MYHTTP
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
    @cookie = res.header['set-cookie'].split('; ')
    @sepuser = @cookie[3]
    /.*(sepuser=".*")/ =~ @sepuser
    @sepuser = $1
    @cookie = @cookie[0]
    puts @cookie
  end

  def get(url)
    login unless @cookie
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host , uri.port)
    request = Net::HTTP::Get.new(uri.path)
    request['Cookie'] = @cookie
    res = http.request(request)
    # puts res # like #<Net::HTTPOK:0x2b3e2e8>

    #detect whether there is redirect
    location = res['location']
    if location
      warn "redirected :#{res['location']}\n"
    end
    res
  end
  def get_with_params(url)
    uri = URI(url)
    Net::HTTP.start(uri.host, uri.port) do |http|
      params = extract_param(url)
      # puts params
      uri.query = URI.encode_www_form(params)
      request = Net::HTTP::Get.new uri
      request['Cookie'] = @cookie
      request['Referer'] = url
      res = http.request request # Net::HTTPResponse object
      res
    end
  end
  def extract_param(url)
    url.slice!('amp;')
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
  def get_portal1(body)
    /<a href="(.*)"><strong>/ =~ body
    $1
  end
  def get_portal2(portal_1)
    /Identity=(.*)&r/ =~ portal_1
    portal_2 = $1
    "http://course.ucas.ac.cn/portal/plogin/main.do?method=gotoIndex&Identity=" + portal_2 + "&roleId=801&sakai.tool.placement.id=exchange"
  end


  def enter_course_site
    @login = "http://sep.ucas.ac.cn/slogin"
    body = get("http://sep.ucas.ac.cn/portal/site/16/801").body
    portal_1 = get_portal1(body)
    if portal_1.nil?
      puts '无法登陆课程网站'
      return
    end
    portal_2 = get_portal2(portal_1)
    res_p2 = get_with_params(portal_2)
    location_of_main = res_p2['location']
    params = extract_param(location_of_main)
    portal_sakai = "http://course.ucas.ac.cn/portal?sakai.session="+ params['sessionId'] +"&_mid=" + params['_mid'] + "&fromUrl="
    res_portal_sakai = get_with_params(portal_sakai)
    set_cookie(res_portal_sakai['set-cookie'])
  end

end

end

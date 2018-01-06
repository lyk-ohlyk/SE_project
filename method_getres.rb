#encoding UTF-8

require 'nokogiri'
require 'net/http'

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

  def get(url)

    # @@count += 1
    # puts @@count
    # puts "the url is:\n#{url}"

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
    # @@count += 1
    # puts @@count
    # puts url

    uri = URI(url)
    Net::HTTP.start(uri.host, uri.port) do |http|
      params = extract_param(url)
      # puts params
      uri.query = URI.encode_www_form(params)
      request = Net::HTTP::Get.new uri
      request['Cookie'] = @cookie
      request['Referer'] = url
      res = http.request request # Net::HTTPResponse object
      # puts res

      # location = res['location']
      # if location
      #   warn "redirected :#{res['location']}\n"
      # end
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

# def set_request_header(path)
#     request = Net::HTTP::Get.new(path)
#     request["Accept"] = "text/html, application/xhtml+xml, */*"
#     request["Accept-Language"] = "zh-CN"
#     request["Connection"] = "Keep-Alive"
#     request["Cookie"] = @sepuser
#     request["DNT"] = 1
#     request["Host"] = "course.ucas.ac.cn"
#     request["Referer"] = "http://sep.ucas.ac.cn/portal/site/16/801"
#     request["User-Agent"] = "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko"
#     request
# end

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
    # res_main = get_with_params(location_of_main, extract_param(location_of_main))
    portal_sakai = "http://course.ucas.ac.cn/portal?sakai.session="+ params['sessionId'] +"&_mid=" + params['_mid'] + "&fromUrl="
    # puts "\n\n#{portal_sakai}"
    res_portal_sakai = get_with_params(portal_sakai)
    set_cookie(res_portal_sakai['set-cookie'])
  end
end

sample = MYHTTP.new("http://sep.ucas.ac.cn/slogin")
# body = sample.get("http://sep.ucas.ac.cn/portal/site/16/801").body
# portal_1 = sample.get_portal1(body)
# portal_2 = sample.get_portal2(portal_1)
#
# res_p2 = sample.get_with_params(portal_2)
#
# location_of_main = res_p2['location']
# params = sample.extract_param(location_of_main)
# #res_main = sample.get_with_params(location_of_main, sample.extract_param(location_of_main))
# portal_sakai = "http://course.ucas.ac.cn/portal?sakai.session="+ params['sessionId'] +"&_mid=" + params['_mid'] + "&fromUrl="
# #puts "\n\n#{portal_sakai}"
# res_portal_sakai = sample.get_with_params(portal_sakai)
# sample.set_cookie(res_portal_sakai['set-cookie'])
sample.enter_course_site




site_content = sample.get("http://course.ucas.ac.cn/portal/site/135737").body
# <a class="icon-sakai-assignment-grades" href="http://cour...">
/grades" href="(.*)"/ =~ site_content
assignment_site_route = $1
assignment_site = sample.get(assignment_site_route).body
# src="http://course.ucas.ac.cn/portal/tool/f0baee91-6d7b-41a1-b1bd-23882cf9140d?panel=Main"
/src="(.*\/tool\/.*)">/ =~ assignment_site
assignments_portal = $1
assignments = sample.get(assignments_portal).body
# <h4><a href="http://course.ucas.ac.cn/portal/tool/f0ba..."
print_control = 1
assignments.scan(/<h4><a href="(.*)"/) do |assignment_site|
  # 需要先向这个网页发送query string后，才能再访问如
  #   http://course.ucas.ac.cn/portal/tool/f0baee91-6d7b-41a1-b1bd-23882cf9140d?panel=null
  # 因为在获取作业的时候，这个网址是不变的，只通过query后的重定向决定页面显示的内容
  sample.get_with_params(assignment_site[0].to_s) # this step is for change_assignment_content
  assignment_content = sample.get(assignment_site[0].to_s).body
  if print_control != -3
    # puts assignment_content
    doc = Nokogiri::HTML(assignment_content)
    puts "### Search for nodes by xpath ###"

    table_column = doc.xpath('//th')
    table_content = doc.xpath('//td')
    for i in 0..table_column.length-1
      s1 = table_column[i].content
      s2 = table_content[i].content
      s1.gsub!(/[[:space:]]+/, '')
      s2.gsub!(/[[:space:]]+/, '')
      puts "#{s1} : #{s2}"
    end
  end
  print_control += 1
end







#
# user_body = sample.get("http://course.ucas.ac.cn/portal/site/~201728001007002/").body
# /membership" href="(.*)"/ =~ user_body
# user_membership = $1
# user_membership_body = sample.get(user_membership).body
# #/<a\shref="(.*)"\starget/ =~ user_membership_body
# /\tsrc="(.*)">/ =~ user_membership_body
# #tool_reset_site = $1
#
# puts class_site = $1
# class_table = sample.get(class_site)
# class_table.body.scan(/<td>(.{8,11})<\/td>/) do |course|
# p course
# end
#
# print_control0 = 1
#
# class_table.body.scan(/<a href="(.*\d{6})"/) do |course_site|
#
#   if print_control0 != -3 #|| print_control0 == 4  # 第 k 门课
#
#     p "下面是课程#{course_site}的作业"
#     p '------------------------------------------------------------------'
#     p course_site[0].to_s
#     site_content = sample.get(course_site[0].to_s).body
#     # <a class="icon-sakai-assignment-grades" href="http://cour...">
#     /grades" href="(.*)"/ =~ site_content
#     assignment_site_route = $1
#     assignment_site = sample.get(assignment_site_route).body
#     # src="http://course.ucas.ac.cn/portal/tool/f0baee91-6d7b-41a1-b1bd-23882cf9140d?panel=Main"
#     /src="(.*\/tool\/.*)">/ =~ assignment_site
#     assignments_portal = $1
#     assignments = sample.get(assignments_portal).body
#     # <h4><a href="http://course.ucas.ac.cn/portal/tool/f0ba..."
#     print_control = 1
#     assignments.scan(/<h4><a href="(.*)"/) do |assignment_site|
#       # 需要先向这个网页发送query string后，才能再访问如
#       #   http://course.ucas.ac.cn/portal/tool/f0baee91-6d7b-41a1-b1bd-23882cf9140d?panel=null
#       # 因为在获取作业的时候，这个网址是不变的，只通过query后的重定向决定页面显示的内容
#       change_assignment_content = sample.get_with_params(assignment_site[0].to_s)
#       assignment_content = sample.get(assignment_site[0].to_s).body
#       if print_control != -3
#         # puts assignment_content
#         doc = Nokogiri::HTML(assignment_content)
#         puts "### Search for nodes by xpath ###"
#
#         table_column = doc.xpath('//th')
#         table_content = doc.xpath('//td')
#         for i in 0..table_column.length-1
#           s1 = table_column[i].content
#           s2 = table_content[i].content
#           s1.gsub!(/[[:space:]]+/, '')
#           s2.gsub!(/[[:space:]]+/, '')
#           puts "#{s1} : #{s2}"
#         end
#
#
#         # doc.xpath('//td').each do |link|
#         #   s = link.content
#         #   # puts 1
#         #   puts s.gsub!(/[[:space:]]+/, '')
#         #   # puts link.content
#         #   # for i in 0..link.content.length-1
#         #   #   puts link.content[i].ord
#         #   # end
#         # end
#
#
#       end
#       print_control += 1
#     end
#   end
#   print_control0 += 1
# end
#
#

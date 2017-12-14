
class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def index
    redirect_to signup_path
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = 'Welcome to the Moyu!'
      redirect_to @user
      # Handle a successful save.
    else
      render 'new'
      # redirect_to signup_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email,
                                 :student_id,
                                 :password,
                                 :password_confirmation)
  end

  def search(student_id, pwd)
    #@student_id = '444896219@qq.com'
    @course_codes = get_classes student_id,pwd
    # if @course_codes.nil?
    #   flash.now[:error] = '无效的账号/密码组合'  #需要改error页面，只有user
    # end
  end

  def get_classes(student_id, pwd)
    #encoding UTF-8
    puts student_id
    puts pwd
    sample = UsersHelper::HTTP.new("http://sep.ucas.ac.cn/slogin")
    sample.set_user(student_id, pwd)
    body = sample.get("http://sep.ucas.ac.cn/portal/site/16/801").body
    portal_1 = sample.find_portal(body)

    if(portal_1.nil?)
      puts '无法登陆课程网站'
      return
    end

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
    class_ids = []
    class_table.body.scan(/<td>(.{8,11})<\/td>/) do |m|
      class_ids.push(m)
    end
    class_ids
  end


end

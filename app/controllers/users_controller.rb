class UsersController < ApplicationController

  # 权限限制的核心步骤：在访问edit、update页面之前，都要做signed_in_user
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers, :lessons]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def new
    if signed_in?
      redirect_to root_path
    else
      @user = User.new
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def create
    if signed_in?
      redirect_to root_path
    else
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
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "档案已更新"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    user = User.find(params[:id])
    if user == current_user
      redirect_to root_path
    else
      user.destroy
      flash[:success] = "User destroyed."
      redirect_to users_url
    end
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end
  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def lessons
    @user = User.find(params[:id])
    @lessons = @user.lessons.paginate(page: params[:page])
    render 'show_lesson'
  end



  private

    def user_params
      params.require(:user).permit(:name, :email,
                                   :student_id,
                                   :password,
                                   :password_confirmation,
                                   :admin)
    end

    # sign_in_user is now in sessions_helper

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def search(student_id, pwd)
      # @student_id = '444896219@qq.com'
      # pwd = ????
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

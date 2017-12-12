
class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'Welcome to the Moyu!'
      redirect_to @user
      # Handle a successful save.
    else
      render 'new'
    end
  end

  def search
    @student_id = '444896219@qq.com'
  end

  private
  def user_params
    params.require(:user).permit(:name, :email,
                                 :student_id,
                                 :password,
                                 :password_confirmation)
  end

end

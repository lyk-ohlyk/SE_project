class SessionsController < ApplicationController


  def new

  end

  def create
    #    render 'new'
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Sign the user in and redirect to the user's show page.
      sign_in user
      redirect_to user
    else
      # Create an error message and re-render the signin form.
      flash.now[:error] = '无效的账号/密码组合' # Not quite right!
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

  def back_to_signin
    redirect_to signin_path
  end

end

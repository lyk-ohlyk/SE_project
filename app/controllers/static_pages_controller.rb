class StaticPagesController < ApplicationController
  def home
    # 该变量用在shared/_micropost_form.html.erb里面
    if signed_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def contact
  end

  def about
  end


end

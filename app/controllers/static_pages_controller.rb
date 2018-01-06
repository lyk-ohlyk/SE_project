class StaticPagesController < ApplicationController
  def home

    if signed_in?
      # 该变量用在shared/_micropost_form.html.erb里面
      @micropost = current_user.microposts.build

      @courses = current_user.lessons
      # @all_assignments = []
      # @courses.each do |course|
      #   @all_assignments.push(course.assignments)
      # end

      @feed_assignments = current_user.assignments_of_lessons.paginate(page: params[:page],  :per_page => 10)
      # _feed.html.erb
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

class RelatecoursesController < ApplicationController
  before_action :signed_in_user

  def create
    @course = Course.find(params[:relatecourse][:lesson_id])
    current_user.learn!(@course)
    # redirect_to @course
    respond_to do |format|
      format.html { redirect_to @course }
      format.js
    end
  end
  def destroy
    @course = Relatecourse.find(params[:id]).lesson
    current_user.unlearn!(@course)
    # redirect_to @course
    respond_to do |format|
      format.html { redirect_to @course }
      format.js
    end
  end


end

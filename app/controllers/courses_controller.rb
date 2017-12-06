class CoursesController < ApplicationController
  def new
  end

  def show
    @course = Course.find(params[:id])
  end

  def search
    @course = Course.find_by_course_code('201M5011H')
  end

end

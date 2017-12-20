class CoursesController < ApplicationController
  def new
  end

  def index
    @courses = Course.all
  end
  
  def show
    @course = Course.find(params[:id])
  end



  def search
    #@course = Course.find_by_course_code('075M4002H')
    @course = Course.find_by_course_code(params[:course_code])
  end

end

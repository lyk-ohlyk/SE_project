class CoursesController < ApplicationController
  def new
  end

  def show
    @course = Course.find(params[:id])
  end
end

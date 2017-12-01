class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy, :open_file]

  # def open_file
  #   File.open("exams_of_class.csv","r+") do |file|
  #     while line = file.gets
  #       #line = file.gets
  #       #puts line
  #       data = line.split(',')
  #       test_exams.read_data(data);
  #     end
  #   end
  # end

  # GET /courses
  # GET /courses.json
  def index
    @courses = Course.all
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(course_params)

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1
  # PATCH/PUT /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course.destroy
    respond_to do |format|
      format.html { redirect_to courses_url, notice: 'Course was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:course).permit(:course_code, :course_name, :course_time, :score, :exam_date, :exam_hour, :exam_place)
    end

    # def read_data(data)
    #   if data.size != 8
    #     warn "can't fit data:"
    #     #warn "#{data}"
    #     return
    #   end
    #   temp_course = Course.new(
    #     course_code:"#{data[1]}",
    #     course_name:"#{data[2]}", 
    #     course_time:"#{data[3]}", 
    #     score:"#{data[4]}", 
    #     exam_date:"#{data[5]}", 
    #     exam_hour:"#{data[6]}", 
    #     exam_place:"#{data[7]}"
    #     )
    #   if !temp_user.save
    #     warn "save error"
    #   end
    # end
end

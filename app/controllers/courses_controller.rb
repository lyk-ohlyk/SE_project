require 'nokogiri'

class CoursesController < ApplicationController
  before_action :signed_in_user, only: :edit
  before_action :admin_user, only: :edit

  def new
  end

  def index
    @courses = Course.all
  end
  
  def show
    @course = Course.find(params[:id])
    @assignments = @course.assignments
  end

  def edit
    @course = Course.find(params[:id])
  end
  def update
    @course = Course.find(params[:id])
    if @course.update_attributes(course_params)
      flash[:success] = "课程已更新"
      redirect_to @course
    else
      render 'edit'
    end
  end

  def search
    #@course = Course.find_by_course_code('075M4002H')
    @course = Course.find_by_course_code(params[:course_code])
  end

  # WARNING: Please dont use this function
  def update_assignments
    site_ids = []
    courses = Course.all
    courses.each do |c|
      if c.site_id && c.site_id.size == 6
        site_ids.push(c.site_id)
      end
    end

    sample = ApplicationHelper::MYHTTP.new("http://sep.ucas.ac.cn/slogin")

    unless sample.enter_course_site
        redirect_to root_path
        return false
    end

    site_ids.each do |site_id|
      puts "############{site_id}"
      course_with_site_id = Course.find_by_site_id(site_id)
      site_content = sample.get("http://course.ucas.ac.cn/portal/site/" + site_id).body
      /grades" href="(.*)"/ =~ site_content
      assignment_site_route = $1
      assignment_site = sample.get(assignment_site_route).body
      /src="(.*\/tool\/.*)">/ =~ assignment_site
      assignments_portal = $1
      assignments = sample.get(assignments_portal).body
      assignments.scan(/<h4><a href="(.*)"/) do |assignment_site|
        sample.get_with_params(assignment_site[0].to_s) # this step is for change_assignment_content
        assignment_content = sample.get(assignment_site[0].to_s).body
        doc = Nokogiri::HTML(assignment_content)
        puts "### Search for nodes by xpath ###"

        table_column = doc.xpath('//th')
        table_content = doc.xpath('//td')
        processed_content = []
        for i in 0..table_column.length-1
          s1 = table_column[i].content
          s2 = table_content[i].content
          s1.gsub!(/[[:space:]]+/, '')
          s2.gsub!(/[[:space:]]+/, '')
          # puts "#{s1} : #{s2}"
          processed_content.push(s2)
        end
        if course_with_site_id.assignments.find_by_title(processed_content[0]) == nil
          ass = Assignment.new
          ass.course_id = course_with_site_id.id
          ass.title = processed_content[0]
          ass.deadline = processed_content[1]
          ass.state = processed_content[2]
          ass.score = processed_content[3]
          ass.save!
        end
      end
    end

    redirect_to root_path
  end


  def admin_user
    redirect_to(root_path) unless current_user.admin?
    end

  private
  def course_params
    params.require(:course).permit(:course_name, :site_id)
  end

end

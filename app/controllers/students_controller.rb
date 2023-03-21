class StudentsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_reponse

    def index
      @students = Student.all
      render json: @students
    end

    def show
      @student = find_student
      render json: @student, status: :ok
    end

    def create 
      @instructor = Instructor.find(params[:instructor_id]) 
      @student = @instructor.students.new(student_params)
      if @student.save
        render json: @student, status: :created
      else
        render_unprocessable_entity_response
      end
    end

    def update
      @instructor = Instructor.find(params[:instructor_id])
      @student = @instructor.students.find(params[:id])
      if @student.update(student_params)
        render json: @student
      else
        render_unprocessable_entity_response
      end
    end
     
    private

    def find_student
        @student = Student.find(params[:id])
    end

    def student_params
        params.permit(:name, :major, :age)
    end

    def render_not_found_reponse
        render json: { error: "Student not found" }, status: :not_found
    end

    def render_unprocessable_entity_response
        render json: { errors: @student.errors.full_messages }, status: :unprocessable_entity
    end


end

class InstructorsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_reponse

    def index
      @instructors = Instructor.all
      render json: @instructors, status: :ok
    end

    def show
        @instructor = find_instructor
        render json: @instructor, serializer: InstructorWithSerializer, status: :ok
    end

    def create
        @instructor = Instructor.new(instructor_params)
        if @instructor.save
            render json: @instructor, status: :created
        else
            render_unprocessable_entity_response
        end
    end

    def update
        @instructor = find_instructor
        if @instructor.update(instructor_params)
            render json: @instructor, status: :ok
        else
            render_unprocessable_entity_response
        end
    end


    private

    def find_instructor
        Instructor.find(params[:id])
    end

    def instructor_params
        params.permit(:name)
    end

    def render_not_found_reponse
        render json: { error: "Instructor not found" }, status: :not_found
    end

    def render_unprocessable_entity_response
        render json: { errors: @instructor.errors.full_messages }, status: :unprocessable_entity
    end
        

end

# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :authorize_request

  def index
    response = Tasks::GetListOfTasks.new(@current_user, permitted_index_params).call

    if response.success?
      render_json_response(data: response.payload, serializer: TaskSerializer, options: { is_collection: true })
    else
      render_json_validation_error(response.error)
    end
  end

  def show
    response = Tasks::GetSingleTask.new(@current_user, permitted_show_params).call

    if response.success?
      render_json_response(data: response.payload, serializer: TaskSerializer)
    else
      render_json_validation_error(response.error)
    end
  end

  def create
    validator = Tasks::CreateParamsValidator.new.call(permitted_create_params)

    if validator.success?
      @to_do_list = @current_user.to_do_lists.find(permitted_create_params[:to_do_list_id])
      @task = Task.new(model_params)

      if @task.save
        render_json_response(data: @task, serializer: TaskSerializer, status: :created)
      else
        render_json_error(status: :unprocessable_entity, error_key: 'database_error')
      end
    else
      render_json_validation_error(validator.errors.to_h)
    end
  end

  def update
    validator = Tasks::UpdateParamsValidator.new.call(permitted_update_params)

    if validator.success?
      @to_do_list = @current_user.to_do_lists.find(permitted_update_params[:to_do_list_id])
      @task = @to_do_list.tasks.find(permitted_update_params[:id])

      if @task.update(permitted_update_params.slice(:title))
        render_json_response(data: @task, serializer: TaskSerializer)
      else
        render_json_error(status: :unprocessable_entity, error_key: 'database_error')
      end
    else
      render_json_validation_error(validator.errors.to_h)
    end
  end

  def destroy
    validator = Tasks::UpdateParamsValidator.new.call(permitted_update_params)

    if validator.success?
      @to_do_list = @current_user.to_do_lists.find(permitted_update_params[:to_do_list_id])
      @task = @to_do_list.tasks.find(permitted_update_params[:id])

      @task.destroy_record

      head :no_content
    else
      render_json_validation_error(validator.errors.to_h)
    end
  end

  private

  def permitted_index_params
    params.permit(:to_do_list_id).to_h
  end

  def permitted_show_params
    params.permit(:to_do_list_id, :id).to_h
  end

  def permitted_create_params
    params.permit(:to_do_list_id, :title).to_h
  end

  def permitted_update_params
    params.permit(:to_do_list_id, :id, :title).to_h
  end

  def model_params
    permitted_create_params.merge({ position: @to_do_list.tasks.size })
  end
end

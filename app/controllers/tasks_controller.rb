# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :authorize_access_request!

  def index
    response = Tasks::GetListOfTasks.new(current_user, permitted_index_params).call

    if response.success?
      render_json_response(data: response.payload, serializer: TaskSerializer, options: { is_collection: true })
    else
      render_json_error(response.error)
    end
  end

  def show
    response = Tasks::GetSingleTask.new(current_user, permitted_show_params).call

    if response.success?
      render_json_response(data: response.payload, serializer: TaskSerializer)
    else
      render_json_error(response.error)
    end
  end

  def create
    response = Tasks::CreateTask.new(current_user, permitted_create_params).call

    if response.success?
      render_json_response(data: response.payload, serializer: TaskSerializer, status: :created)
    else
      render_json_error(response.error)
    end
  end

  def update
    response = Tasks::UpdateTask.new(current_user, permitted_update_params).call

    if response.success?
      render_json_response(data: response.payload, serializer: TaskSerializer)
    else
      render_json_error(response.error)
    end
  end

  def destroy
    response = Tasks::DestroyTask.new(current_user, permitted_destroy_params).call

    if response.success?
      head :no_content
    else
      render_json_error(response.error)
    end
  end

  def change_position
    response = Tasks::ChangePositionOfTask.new(current_user, permitted_change_position_params).call

    if response.success?
      render_json_response(data: response.payload, serializer: TaskSerializer)
    else
      render_json_error(response.error)
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

  def permitted_destroy_params
    params.permit(:to_do_list_id, :id).to_h
  end

  def permitted_change_position_params
    params.permit(:to_do_list_id, :id, :new_position).to_h
  end
end

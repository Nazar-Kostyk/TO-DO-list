# frozen_string_literal: true

class ToDoListsController < ApplicationController
  before_action :authorize_access_request!

  def index
    response = Actions::ToDoLists::GetListOfToDoLists.new(current_user).call

    if response.success?
      render_json_response(data: response.payload, serializer: ToDoListSerializer, options: { is_collection: true })
    else
      render_json_error(response.error)
    end
  end

  def show
    response = Actions::ToDoLists::GetSingleToDoList.new(current_user, permitted_show_params).call

    if response.success?
      render_json_response(data: response.payload, serializer: ToDoListSerializer)
    else
      render_json_error(response.error)
    end
  end

  def create
    response = Actions::ToDoLists::CreateToDoList.new(current_user, permitted_create_params).call

    if response.success?
      render_json_response(data: response.payload, serializer: ToDoListSerializer, status: :created)
    else
      render_json_error(response.error)
    end
  end

  def update
    response = Actions::ToDoLists::UpdateToDoList.new(current_user, permitted_update_params).call

    if response.success?
      render_json_response(data: response.payload, serializer: ToDoListSerializer)
    else
      render_json_error(response.error)
    end
  end

  def destroy
    response = Actions::ToDoLists::DestroyToDoList.new(current_user, permitted_destroy_params).call

    if response.success?
      head :no_content
    else
      render_json_error(response.error)
    end
  end

  private

  def permitted_show_params
    params.permit(:id).to_h
  end

  def permitted_create_params
    params.permit(:title, :description).to_h
  end

  def permitted_update_params
    params.permit(:id, :title, :description).to_h
  end

  def permitted_destroy_params
    params.permit(:id).to_h
  end
end

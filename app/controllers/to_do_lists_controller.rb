# frozen_string_literal: true

class ToDoListsController < ApplicationController
  before_action :authorize_request

  def index
    render_json_response(data: @current_user.to_do_lists,
                         serializer: ToDoListSerializer,
                         options: { is_collection: true })
  end

  def show
    validator = ToDoLists::Show::ShowParamsValidator.new.call(permitted_show_params)

    if validator.success?
      render_json_response(data: @current_user.to_do_lists.find(permitted_show_params[:id]),
                           serializer: ToDoListSerializer)
    else
      render_json_validation_error(validator.errors.to_h)
    end
  end

  def create
    validator = ToDoLists::Create::CreateParamsValidator.new.call(permitted_create_params)

    if validator.success?
      @to_do_list = ToDoList.new(model_params)
      if @to_do_list.save
        render_json_response(data: @to_do_list, serializer: ToDoListSerializer, status: :created)
      else
        render_json_error(status: :unprocessable_entity, error_key: 'database_error')
      end
    else
      render_json_validation_error(validator.errors.to_h)
    end
  end

  def update; end

  def destroy; end

  def permitted_show_params
    params.permit(:id).to_h
  end

  def permitted_create_params
    params.permit(:title, :description).to_h
  end

  def model_params
    permitted_create_params.merge({ user_id: @current_user.id })
  end
end

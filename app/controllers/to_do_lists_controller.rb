# frozen_string_literal: true

class ToDoListsController < ApplicationController
  before_action :authorize_request

  def index; end

  def show; end

  def create
    validator = ToDoLists::Create::CreateParamsValidator.new.call(permitted_create_params)

    if validator.success?
      @to_do_list = ToDoList.new(model_params)
      if @to_do_list.save
        render_json_response(to_do_list: @to_do_list, status: :created)
      else
        render_json_error(status: :unprocessable_entity, error_key: 'database_error')
      end
    else
      render_json_validation_error(validator.errors.to_h)
    end
  end

  def update; end

  def destroy; end

  def permitted_create_params
    params.permit(:title, :description).to_h
  end

  def model_params
    permitted_create_params.merge({ user_id: @current_user.id })
  end

  def render_json_response(to_do_list:, status: :ok)
    render json: ToDoListSerializer.new(to_do_list).serializable_hash, status: status
  end
end

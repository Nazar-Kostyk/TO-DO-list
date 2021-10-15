# frozen_string_literal: true

class ToDoListsController < ApplicationController
  before_action :authorize_access_request!

  def index
    render_json_response(data: current_user.to_do_lists.includes(:tasks),
                         serializer: ToDoListSerializer,
                         options: { is_collection: true })
  end

  def show
    validator = ToDoLists::ShowParamsValidator.new.call(permitted_show_params)

    if validator.success?
      render_json_response(data: current_user.to_do_lists.find(permitted_show_params[:id]),
                           serializer: ToDoListSerializer)
    else
      render_json_validation_error(validator.errors.to_h)
    end
  end

  def create
    validator = ToDoLists::CreateParamsValidator.new.call(permitted_create_params)

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

  # Temporarly disabling rubocop offense.
  # Will be fixed in a separate PR.
  def update # rubocop:disable Metrics/AbcSize
    validator = ToDoLists::UpdateParamsValidator.new.call(permitted_update_params)

    if validator.success?
      @to_do_list = current_user.to_do_lists.find(permitted_show_params[:id])

      if @to_do_list.update(permitted_update_params.slice(:title, :description))
        render_json_response(data: @to_do_list, serializer: ToDoListSerializer)
      else
        render_json_error(status: :unprocessable_entity, error_key: 'database_error')
      end
    else
      render_json_validation_error(validator.errors.to_h)
    end
  end

  def destroy
    validator = ToDoLists::DestroyParamsValidator.new.call(permitted_destroy_params)

    if validator.success?
      @to_do_list = current_user.to_do_lists.find(permitted_show_params[:id])
      if @to_do_list.destroy
        head :no_content
      else
        render_json_error(status: :unprocessable_entity, error_key: 'database_error')
      end
    else
      render_json_validation_error(validator.errors.to_h)
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

  def model_params
    permitted_create_params.merge({ user_id: current_user.id }).compact_blank
  end
end

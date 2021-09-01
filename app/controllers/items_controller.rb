class ItemsController < ApplicationController
  wrap_parameters format: []
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_message

  def index
    if params[:user_id]
      user = User.find_by!(id: params[:user_id])
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user
  end

  def show
    if params[:id]
      user = User.find_by!(id: params[:user_id])
      item = user.items.find_by!(id: params[:id])
    else
      user = User.find_by!(id: params[:user_id])
      item = user.items
    end
    render json: item, include: :user
  end

  def create
    item = Item.create(item_params)
    render json: item, status: :created
  end

  private

  def render_not_found_message
    render json: { error: "Not Found" }, status: :not_found
  end

  def item_params
    params.permit(:name, :description, :price, :user_id)
  end

end

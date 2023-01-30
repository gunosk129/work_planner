class WorkersController < ApplicationController
  before_action :set_worker, only: [:show, :update, :destroy]

  def create
    @worker = Worker.new(permitted_params)
    if @worker.save
      render json: @worker, status: :created
    else
      render json: { errors: @worker.errors }, status: :unprocessable_entity
    end
  end

  def index
    @workers = Worker.all
    render json: @workers, status: :ok
  end

  def show
    render json: @worker, status: :ok
  end

  def update
    if @worker.update(permitted_params)
      render json: @worker
    else
      render json: @worker.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @worker.destroy
  end

  private

  def permitted_params
    params.permit(
      :name
    )
  end

  def set_worker
    begin
      @worker = Worker.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { message: "Worker not found" }, status: :not_found
    end
  end
end

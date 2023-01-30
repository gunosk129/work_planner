class ShiftsController < ApplicationController
  before_action :check_params_to_update, only: [:update]
  before_action :set_worker, only: [:index, :show, :create, :update, :destroy]
  before_action :set_shift, only: [:show, :update, :destroy]

  def index
    @shifts = @worker.shifts
    render json: @shifts, status: :ok
  end

  def show
    render json: @shift
  end

  def create
    shift = @worker.shifts.build(permitted_params)

    if shift.save
      render json: shift, status: :created, location: @shift
    else
      render json: shift.errors, status: :unprocessable_entity
    end
  end

  def update
    if @shift.update(permitted_update_params)
      render json: @shift
    else
      render json: @shift.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @shift.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_shift
    begin
      @shift = @worker.shifts.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: 'Shift not found' }, status: :not_found
    end
  end

  def set_worker
    begin
      @worker = Worker.find(params[:worker_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: 'Worker not found' }, status: :not_found
    end
  end

  def permitted_params
    params.permit(:date, :slot)
  end

  def permitted_update_params
    params.permit(:slot)
  end

  def check_params_to_update
    if params[:date]
      render json: { error: "You cannot update the date of a shift." },  status: :unprocessable_entity
    end
  end
end

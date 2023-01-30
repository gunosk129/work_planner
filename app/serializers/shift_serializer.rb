class ShiftSerializer < ActiveModel::Serializer
  attributes :id, :slot, :date, :start_time, :end_time, :created_at, :updated_at
  belongs_to :worker

  def start_time
    object.start_time
  end

  def end_time
    object.end_time
  end
end

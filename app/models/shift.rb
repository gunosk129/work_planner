class Shift < ApplicationRecord
  belongs_to :worker

  enum slot: {
    zero_to_eight: 0,
    eight_to_sixteen: 1,
    sixteen_to_twenty_four: 2
  }

  # Validate the slot
  validates :slot, presence: true, inclusion: { in: slots.keys }
  validates :date, presence: true

  # Validate that a worker can only have one shift per day
  validate :worker_can_have_only_one_shift_per_day, on: :create

  # Get the start and end times based on the slot
  def start_time
    case slot
    when 'zero_to_eight'
      0
    when 'eight_to_sixteen'
      8
    when 'sixteen_to_twenty_four'
      16
    end
  end

  def end_time
    case slot
    when 'zero_to_eight'
      8
    when 'eight_to_sixteen'
      16
    when 'sixteen_to_twenty_four'
      24
    end
  end

  private

  def worker_can_have_only_one_shift_per_day
    return unless worker

    if worker.shifts.where(date: date).exists?
      errors.add(:worker, "can only have one shift per day")
    end
  end
end

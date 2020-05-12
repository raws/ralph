class User < ApplicationRecord
  # Validations
  validates :email, presence: true, length: { maximum: 256 }
  validates :name, presence: true, length: { maximum: 256 }
  validates :zulip_id, presence: true, numericality: { only_integer: true }

  def self.born_today
    today = Date.current
    where('EXTRACT(MONTH FROM born_on) = ? AND EXTRACT(DAY FROM born_on) = ?',
      today.month, today.day)
  end
end

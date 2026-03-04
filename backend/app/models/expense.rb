class Expense < ApplicationRecord
  belongs_to :category

  validates :amount, numericality: { greater_than: 0 }
  validates :description, presence: true
  validates :date, presence: true

  validate :date_cannot_be_in_the_future

  private

  def date_cannot_be_in_the_future
    return if date.blank?

    if date > Date.current
      errors.add(:date, "cannot be in the future")
    end
  end
end

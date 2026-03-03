class Expense < ApplicationRecord
  belongs_to :category

  scope :by_month, ->(year, month) {
    return all unless year.present? && month.present?

    start_date = Date.new(year, month, 1)
    end_date = start_date.end_of_month
    where(date: start_date.beginning_of_day..end_date.end_of_day)
  }
end

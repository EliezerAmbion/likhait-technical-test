require 'rails_helper'

RSpec.describe Expense, type: :model do
  describe ".by_month" do
    let(:category) { Category.create!(name: "Food") }

    let!(:older_expense) do
      Expense.create!(
        description: "Old Expense",
        amount: 10.0,
        date: Date.yesterday,
        category: category
      )
    end

    let!(:newer_expense) do
      Expense.create!(
        description: "New Expense",
        amount: 25.0,
        date: Date.today,
        category: category
      )
    end

    it "returns expenses in date order, oldest first" do
      expenses = Expense.by_month(Date.today.year, Date.today.month).order(:date)

      expect(expenses.first).to eq(older_expense)
      expect(expenses.last).to eq(newer_expense)
    end

    it "returns all expenses if year or month is missing" do
      expect(Expense.by_month(nil, Date.today.month)).to include(older_expense, newer_expense)
      expect(Expense.by_month(Date.today.year, nil)).to include(older_expense, newer_expense)
      expect(Expense.by_month(nil, nil)).to include(older_expense, newer_expense)
    end
  end
end

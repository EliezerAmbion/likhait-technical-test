require 'rails_helper'

RSpec.describe Expense, type: :model do
  let(:category) { Category.create!(name: "Food") }

  subject do
    described_class.new(
      description: "Lunch",
      amount: 10.50,
      category: category,
      date: Date.current
    )
  end

  describe "associations" do
    it { should belong_to(:category) }
  end

  describe "validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is invalid without a description" do
      subject.description = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:description]).to include("can't be blank")
    end

    it "is invalid without a date" do
      subject.date = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:date]).to include("can't be blank")
    end

    it "is invalid with amount <= 0" do
      subject.amount = 0
      expect(subject).not_to be_valid
      expect(subject.errors[:amount]).to include("must be greater than 0")

      subject.amount = -5
      expect(subject).not_to be_valid
      expect(subject.errors[:amount]).to include("must be greater than 0")
    end
  end

  describe "custom validation: date_cannot_be_in_the_future" do
    it "is valid if the date is today" do
      subject.date = Date.current
      expect(subject).to be_valid
    end

    it "is valid if the date is in the past" do
      subject.date = Date.yesterday
      expect(subject).to be_valid
    end

    it "is invalid if the date is in the future" do
      subject.date = Date.tomorrow
      expect(subject).not_to be_valid
      expect(subject.errors[:date]).to include("cannot be in the future")
    end
  end
end

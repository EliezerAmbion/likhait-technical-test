class Api::ExpensesController < ApplicationController
  before_action :set_expense, only: [ :update, :destroy ]

  def index
    expenses = Expense.includes(:category)
                      .order(date: :desc)
                      .by_month(params[:year]&.to_i, params[:month]&.to_i)

    render json: expenses.map { |expense| format_expense(expense) }
  end

  def create
    expense = Expense.new(expense_params)

    if expense.save
      render json: {
        message: "Expense created successfully",
        expense: format_expense(expense)
    }, status: :created
    else
      render json: { errors: expense.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @expense.update(expense_params)
      render json: {
        message: "Expense updated successfully",
        expense: format_expense(@expense)
      }, status: :ok
    else
      render json: { errors: @expense.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @expense.destroy
    render json: { message: "Expense deleted successfully" }, status: :ok
  end

  private

  def set_expense
    @expense = Expense.find(params[:id])
  end

  def expense_params
    params.require(:expense).permit(:description, :amount, :category_id, :date)
  end

  def format_expense(expense)
    {
      id: expense.id,
      description: expense.description,
      amount: expense.amount.to_f,
      category: expense.category.name,
      date: expense.date.to_s,
      created_at: expense.created_at,
      updated_at: expense.updated_at
    }
  end
end

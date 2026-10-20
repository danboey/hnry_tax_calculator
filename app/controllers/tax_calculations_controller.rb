class TaxCalculationsController < ApplicationController

  def index
  end

  def create
    @income = params[:income]
    @result = TaxCalculator.new(@income).calculate

    render :index

  rescue ArgumentError => e
    @error = e.message
    render :index, status: :unprocessable_content
  end

end

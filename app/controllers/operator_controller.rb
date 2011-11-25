class OperatorController < ApplicationController
  def schema
    @days = Day.order(:date)
  end
end

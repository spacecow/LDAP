require 'csv'

module OperatorHelper
  def turn_to_csv 
    CSV.generate do |csv| 
      #Product.find(:all).each do |product|
      #  csv << ... add stuff here ...
      #end
      csv << Day.first
    end
  end
end

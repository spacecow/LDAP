require 'csv'
#require 'fastercsv/lib/faster_csv'

module OperatorHelper
  def turn_to_csv 
    CSV.generate do |csv| 
      cols = ["column one", "column two", "column three"]
      csv << cols
      @monthstats.each do |mstat|
        csv << [mstat.userid, mstat.path]
      end
    end
  end
end

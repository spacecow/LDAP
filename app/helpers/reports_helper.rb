require 'spreadsheet'

module ReportsHelper
  def turn_to_xls
    ##Spreadsheet.client_encoding = 'UTF-8'
    #book = Spreadsheet::Workbook.new
    #sheet = book.create_worksheet :name => "LDAP"
    #sheet.row(0).concat %w(Name)
    #book.write 'public/excel-file.xls' 
    #send_file 'public/excel-file.xls', :content_type => "application/vnd.ms-excel",
  end
end

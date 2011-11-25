require 'stringio'
 
module Kernel
  def capture_stdout
    out = StringIO.new
    $stdout = out
    yield
    return out
  ensure
    $stdout = STDOUT
  end
end

class User < ActiveRecord::Base
  def calculate_account_size
    self.size = %x[du #{path} -s].split[0]
    self.size = "-" if !$?.success?
    self.save
  end
end

# == Schema Information
#
# Table name: users
#
#  id         :integer(4)      not null, primary key
#  path       :string(255)
#  created_at :datetime
#  updated_at :datetime
#


class User < ActiveRecord::Base
  def calculate_account_size
    %x[du #{path} -s]
  end
end

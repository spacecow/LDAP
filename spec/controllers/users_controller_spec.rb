require 'spec_helper'

describe UsersController do
  it "requires a list of users" do
    controller.send("userlist").map(&:path).should eq %w(/home/test)
  end
end

FactoryGirl.define do
  factory :account do
    path "/home/test"
  end

  factory :dailystat do
    path "/home/factory"
    gid_num 1
    gid_string 'ghost'
  end

  factory :day do
    date "2011-11-28"
  end

  factory :monthstat do
    path "/home/factory"
  end

  factory :report do
    date Date.parse('2011-11-01')
  end

  factory :user do
  end
end

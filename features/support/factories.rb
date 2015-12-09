require 'factory_girl'

FactoryGirl.define do
#   # factory :user do |f|
#   #   f.email 'iot@iot.com'
#   #   f.password '12345678'    
#   # end

#   # factory :device do |f|
#   #   f.association :user
#   #   f.device_id 'dev01'
#   # end

  factory :dmodel do |f|
    f.name 'JMC-100'
    f.description 'JMC-100'
  end
end
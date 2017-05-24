require 'faker'

module Test
  class User < BaseModel
    key(:email) { Faker::Internet.email }
    key(:password) { Faker::Internet.password }
  end
end
require 'faker'

module Test
  class Address < BaseModel
    key(:first_name) { Faker::Name.first_name }
    key(:last_name) { Faker::Name.last_name }
    key(:street_address) { Faker::Address.street_address }
    key(:secondary_address) { Faker::Address.secondary_address }
    key(:city) { Faker::Address.city }
    key(:state) { Faker::Address.state }
    key(:zip_code) { Faker::Address.zip_code }
    key(:note) { "Hi Mom" }
  end
end

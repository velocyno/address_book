module AddressBook
  module Data
    class Address < Base

      key(:first_name) { Faker::Name.first_name }
      key(:last_name) { Faker::Name.last_name }
      key(:street_address) { Faker::Address.street_address }
      key(:secondary_address) { Faker::Address.secondary_address }
      key(:city) { Faker::Address.city }
      key(:state) { Faker::Address.state }
      key(:zip_code) { Faker::Address.zip }

    end
  end
end

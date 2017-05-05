json.extract! address, :id, :first_name, :last_name, :line_1, :line_2, :city, :state, :zip_code, :country, :birthday, :note, :created_at, :updated_at
json.url address_url(address, format: :json)

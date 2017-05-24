module Test
  class User < BaseModel

    key(:email_address) { Defaults.translate :email_address }
    key(:password) { Defaults.translate :password }

  end
end
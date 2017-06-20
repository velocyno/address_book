module AddressBook
  module Data
    class User < Base

      key(:email_address) { Defaults.translate :email_address }
      key(:password, required: false) { Defaults.translate :password }

      def self.convert(hash, *args)
        hash['email_address'] = hash.delete('email') if hash.key?('email')
        super(hash, *args)
      end
    end
  end
end

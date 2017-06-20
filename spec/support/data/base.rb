require 'data_magic/standard_translation'
require 'faker'

module AddressBook
  module Data
    class Base < WatirModel

      class << self

        attr_writer :required_keys

        def required_keys
          @required_keys ||= []
        end

        # define a key and an optional block that provides a default value for the key
        def key(symbol, required: true, &block)
          keys << symbol unless @keys.include? symbol
          required_keys << symbol if required
          attr_accessor symbol
          defaults[symbol] = block if block
        end
      end

      def eql?(other)
        self.class.required_keys.all? { |k| send(k) == other[k] }
      end

      alias_method :==, :eql?

      key(:id, required: false) {}

    end

    class Defaults
      include DataMagic::StandardTranslation

      def self.translate(key)
        return new.send(:characters, 10) if key == :password
        new.send(key)
      end
    end
  end
end

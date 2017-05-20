require 'active_support/hash_with_indifferent_access'

class BaseModel < WatirModel

  attr_accessor :id

  def self.convert(hash, *args)
    hash.deep_symbolize_keys!
    id = hash.delete :id

    model = super
    model.tap { |m| m.id = id }
  end

  def eql?(other)
    keys.all? {|k| send(k) == other.send(k)}
  end
  alias_method :==, :eql?

end

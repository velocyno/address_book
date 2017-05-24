require 'data_magic/standard_translation'

class BaseModel < WatirModel

  attr_accessor :id

end

class Defaults
  include DataMagic::StandardTranslation

  def self.translate(key)
    return new.send(:characters, 10) if key == :password
    new.send(key)
  end
end

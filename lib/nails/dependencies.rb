# lib/nails/dependencies.rb

class Object
  def self.const_missing(c)
    require Nails.to_underscore(c.to_s)
    Object.const_get(c)
  end
end

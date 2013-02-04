# rulers/lib/rulers/util.rb

module Rulers
  # This method is the same as the one from ActiveSupport
  # but let's not bog down with AS until we need to.
  def self.to_underscore string
    string.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
      gsub(/([a-z\d])([A-Z])/, '\1_\2').
      tr("-","_").
      downcase
  end
end


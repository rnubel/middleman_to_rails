require 'middleman_to_rails/version'
require 'middleman_to_rails/translator'

module MiddlemanToRails
  def self.convert!(path)
    Translator.new(File.read(path)).translate
  end
end

require 'nokogiri'
require 'zeitwerk'

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect 'gpx' => 'GPX'
loader.setup

module GPX
  InvalidSplit = Class.new(StandardError)
end

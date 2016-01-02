require "sinatra"
require "sinatra/config_file"
require "sinatra/reloader" if development?
require "rexml/document"
require "net/http"
require "slim"
require "uri"
require File.expand_path("../controller", __FILE__)
Dir.glob("helpers/**/*.rb").each do |h|
  require File.expand_path("../#{h}", __FILE__)
end

config_file File.expand_path("../config/config.yml", __FILE__)
configure do
  Dir.glob("config/**/*.xml").each do |c|
    set File.basename(c, ".*").to_sym, REXML::Document.new(File.open(File.expand_path("../#{c}", __FILE__)))
  end
end

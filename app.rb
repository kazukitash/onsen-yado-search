require "sinatra"
require "sinatra/config_file"
require "sinatra/reloader" if development?
require "slim"
require "rexml/document"
require File.expand_path("../controller", __FILE__)

config_file File.expand_path("../config/config.yml", __FILE__)
configure do
  Dir.glob("config/**/*.xml").each do |c|
    set File.basename(c, ".*").to_sym, REXML::Document.new(File.open(File.expand_path("../#{c}", __FILE__)))
  end
end

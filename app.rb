require "sinatra"
require "slim"
require "sinatra/reloader" if development?
require File.expand_path('../controller', __FILE__)
